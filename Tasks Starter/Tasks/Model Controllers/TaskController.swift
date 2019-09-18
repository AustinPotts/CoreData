//
//  TaskController.swift
//  Tasks
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData


class TaskController {
    
    let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!
    
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
                
            }
            
        }.resume()
        
        
    }
    
    func updateTasks(with representations: [TaskRepresentation]){
        
        
        
        
        
        
        
        
        
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier)})
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        //Make a mutable copy of Dictionary above
        var tasksToCreate = representationsByID
        
        
        
        do {
            let context = CoreDataStack.share.mainContext
            
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
                task.priority = representation.priortiy
                
                tasksToCreate.removeValue(forKey: identifier)
                
            }
            
            for representation in tasksToCreate.values{
                Task(taskRepresentation: representation, context: context)
            }
            
            CoreDataStack.share.saveToPersistentStore()
            
        } catch {
            NSLog("Error fetching tasks from persistent store: \(error)")
        }
        
        
    }
    
    
    
    
    @discardableResult func createTask(with name: String, notes: String?, priotirty: TaskPriority) -> Task {
        let task = Task(name: name, notes: notes, priority: priotirty, context: CoreDataStack.share.mainContext)
       
        CoreDataStack.share.saveToPersistentStore()
        
        
        return task
    }
    
    func updateTask(task: Task, with name: String, notes: String?, priority: TaskPriority){
        task.name = name
        task.notes = notes
        task.priority = priority.rawValue
        
        CoreDataStack.share.saveToPersistentStore()
    }
    
    func delete(task: Task) {
        CoreDataStack.share.mainContext.delete(task)
        CoreDataStack.share.saveToPersistentStore()
    }
    
    
}
