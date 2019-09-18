//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData

enum TaskPriority: String, CaseIterable {
    case low
    case normal
    case high
    case critical
    
}

//Core data already created the Task class, so we just want to add some functionality to it
extension Task {
    
    var taskRepresentation: TaskRepresentation? {
        guard let name = name,
            let priority = priority,
            let identifier = identifier?.uuidString else{return nil}
        return TaskRepresentation(name: name, notes: notes, identifier: identifier, priortiy: priority)
        
    }
    
    convenience init(name: String, notes: String?, priority: TaskPriority, identifier: UUID = UUID(), context: NSManagedObjectContext){
        
        //Setting up the generic NSManageObject functionality of the model object
        //Generic clay
        self.init(context: context)
        
        //Once we have the clay we can start sculpting it into our unique model obejct
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue
        self.identifier = identifier
        
    }
    
   @discardableResult convenience init?(taskRepresentation: TaskRepresentation, context: NSManagedObjectContext) {
        
        guard let identifier = UUID(uuidString: taskRepresentation.identifier),
            let priority = TaskPriority(rawValue: taskRepresentation.priortiy) else {return nil}
        
        
        self.init(name: taskRepresentation.name, notes: taskRepresentation.notes, priority: priority, identifier: identifier, context: context)
        
        
    }
    
}
