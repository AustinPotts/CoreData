//
//  TaskRepresentation.swift
//  Tasks
//
//  Created by Austin Potts on 9/18/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import Foundation


//The task representation is an axact copy of the data model without core data
struct TaskRepresentation: Codable {
    
    let name: String
    let notes: String?
    let identifier: String
    let priortiy: String
    
}
