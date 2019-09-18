//
//  TaskController.swift
//  Tasks
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation


class TaskController {
    
    let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!
    
    func fetchTaskFromServer(completion: @escaping()-> Void = {}) {
        
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
