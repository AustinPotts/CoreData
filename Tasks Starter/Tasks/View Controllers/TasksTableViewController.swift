//
//  TasksTableViewController.swift
//  Tasks
//
//  Created by Austin Potts on 9/16/19.
//  Copyright © 2019 Andrew R Madsen. All rights reserved.
//

import UIKit
import CoreData


class TasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let taskController = TaskController()
    
    // NOTE! This is not a good, efficient way to do this, as the fetch request
    // will be executed every time the tasks property is accessed. We will
    // learn a better way to do this later.
    
    lazy var fetchResultController: NSFetchedResultsController<Task> = {
        
        //Create the fetch request
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        //Sort Fetched Results
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)] //priorty is name of attribute
        
        
        // YOU MUST make the descriptor with the same key path as the sectionNameKeyPath be the first sort descriptor in this array
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.share.mainContext, sectionNameKeyPath: "priority", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for FRC: \(error)")
        }
        
        
        return frc
        
    }()
    
    
    var tasks: [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
           let tasks = try CoreDataStack.share.mainContext.fetch(fetchRequest)
            return tasks
        } catch {
            NSLog("Error fetching tasks \(error)")
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)

        cell.textLabel?.text = tasks[indexPath.row].name

        return cell
    }
    


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let task = tasks[indexPath.row]
            
            //Always delete the model object
            taskController.delete(task: task)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

  
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaskDetail" {
            guard let detailVC = segue.destination as? TaskDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            detailVC.task = tasks[indexPath.row]
            detailVC.taskController = taskController
        } else if segue.identifier == "ShowCreateTask" {
            guard let detailVC = segue.destination as? TaskDetailViewController else { return }
            
            detailVC.taskController = taskController
        }
        
        
        
    }
    

}
