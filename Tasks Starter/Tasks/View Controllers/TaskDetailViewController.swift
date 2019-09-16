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
        
        if let task = task {
            taskController?.updateTask(task: task, with: name, notes: notes)
        } else {
            taskController?.createTask(with: name, notes: notes)
            
        }
        navigationController?.popViewController(animated: true)
    }
    

    func updateViews(){
        
        title = task?.name ?? "Create Task"
        
        nameTextField.text = task?.name
        notesTextView.text = task?.notes
        
    }

}
