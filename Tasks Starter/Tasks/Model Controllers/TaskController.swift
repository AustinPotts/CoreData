//
//  TaskController.swift
//  Tasks
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData


enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}


class TaskController {
    //Using this as the view did load for task controller
    init(){
        fetchTaskFromServer()
    }
    
    
    let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!
    
    
    func putTask(task: Task, completion: @escaping()-> Void = {}) {
        
        let identifier = task.identifier ?? UUID()
        task.identifier = identifier
        
        let requestURL = baseURL.appendingPathComponent(identifier.uuidString).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let taskRepresentation = task.taskRepresentation else{
            NSLog("Error")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(taskRepresentation)
        } catch {
            NSLog("Error encoding task: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error{
                NSLog("Error putting task: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
        
    }
    
    func fetchTaskFromServer(completion: @escaping()-> Void = {}) {
        
        
        //Apending path component adds a forward slash where as appending path extension adds period
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error{
                NSLog("error fetching tasks: \(error)")
                completion()
            }
            
            guard let data = data else{
                NSLog("Error getting data task:")
                completion()
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                //Gives us full array of task representation
                let taskRepresentations = Array(try decoder.decode([String: TaskRepresentation].self, from: data).values)
                
                self.updateTasks(with: taskRepresentations)
                
                
                
            } catch {
                NSLog("Error decoding: \(error)")
                
            }
            
        }.resume()
        
        
    }
    
    func updateTasks(with representations: [TaskRepresentation]){
        
        
        
        
        
        
        
        
        
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier)})
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        //Make a mutable copy of Dictionary above
        var tasksToCreate = representationsByID
        
        
        let context = CoreDataStack.share.container.newBackgroundContext()
        context.performAndWait {
            
        do {
            
            
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
                                                        //Name of Attibute
            fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
            
            //Which of these tasks already exist in core data?
            
            
            
            let exisitingTask = try context.fetch(fetchRequest)
            
            //Which need to be updated? Which need to be put into core data?
            for task in exisitingTask {
                guard let identifier = task.identifier,
                    // This gets the task representation that corresponds to the task from Core Data
                    let representation = representationsByID[identifier] else{return}
                
                task.name = representation.name
                task.notes = representation.notes
                task.priority = representation.priority
                
                tasksToCreate.removeValue(forKey: identifier)
                
            }
            //Take these tasks that arent in core data and create
            for representation in tasksToCreate.values{
                Task(taskRepresentation: representation, context: context)
            }
            
            CoreDataStack.share.save(context: context)
            
        } catch {
            NSLog("Error fetching tasks from persistent store: \(error)")
        }
        }
        
        
    }
    
    
    
    
    @discardableResult func createTask(with name: String, notes: String?, priotirty: TaskPriority) -> Task {
        let task = Task(name: name, notes: notes, priority: priotirty, context: CoreDataStack.share.mainContext)
       
        CoreDataStack.share.save()
        putTask(task: task)
        return task
    }
    
    func updateTask(task: Task, with name: String, notes: String?, priority: TaskPriority){
        task.name = name
        task.notes = notes
        task.priority = priority.rawValue
        putTask(task: task)
        
        CoreDataStack.share.save()
    }
    
    func delete(task: Task) {
        CoreDataStack.share.mainContext.delete(task)
        CoreDataStack.share.save()
    }
    
    
}
