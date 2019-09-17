//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation
import CoreData

enum TaskPriority: String {
    case low
    case normal
    case high
    case critical
    
}

//Core data already created the Task class, so we just want to add some functionality to it
extension Task {
    
    convenience init(name: String, notes: String?, priority: TaskPriority, context: NSManagedObjectContext){
        
        //Setting up the generic NSManageObject functionality of the model object
        //Generic clay
        self.init(context: context)
        
        //Once we have the clay we can start sculpting it into our unique model obejct
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue
        
    }
    
}
