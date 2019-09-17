//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var prioritySegmentControl: UISegmentedControl!
    
    var taskController: TaskController?
    var task: Task?
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text,
        let notes = notesTextView.text,
            !name.isEmpty else {return}
        
        let index = prioritySegmentControl.selectedSegmentIndex
        
        let priority = TaskPriority.allCases[index]
        
        //Just one way to do it
//        switch index {
//        case 0:
//            priority = .low
//        case 1:
//            priority = .normal
//        case 2:
//            priority = .high
//        case 3:
//            priority = .critical
//
//        }
        
        
        if let task = task {
            taskController?.updateTask(task: task, with: name, notes: notes, priority: priority)
        } else {
            taskController?.createTask(with: name, notes: notes, priotirty: priority )
            
        }
        navigationController?.popViewController(animated: true)
    }
    

    func updateViews(){
        
        title = task?.name ?? "Create Task"
        
        nameTextField.text = task?.name
        notesTextView.text = task?.notes
        
        if let priorityString = task?.priority,
            let priority = TaskPriority(rawValue: priorityString) {
            
            let index = TaskPriority.allCases.firstIndex(of: priority) ?? 0
        
        prioritySegmentControl.selectedSegmentIndex = index
        
        }
    }

}
