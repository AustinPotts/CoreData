//
//  TaskController.swift
//  Tasks
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation


class TaskController {
    
    func createTask(with name: String, notes: String?) -> Task {
        let task = Task(name: name, notes: notes, context: CoreDataStack.share.mainContext)
       
        CoreDataStack.share.saveToPersistentStore()
        
        
        return task
    }
    
    func updateTask(task: Task, with name: String, notes: String?){
        task.name = name
        task.notes = notes
        
        CoreDataStack.share.saveToPersistentStore()
    }
    
    func delete(task: Task) {
        CoreDataStack.share.mainContext.delete(task)
        CoreDataStack.share.saveToPersistentStore()
    }
    
    
}
