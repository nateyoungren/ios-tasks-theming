//
//  TaskDetailViewController.swift
//  Tasks
//
//  Created by Andrew R Madsen on 8/11/18.
//  Copyright © 2018 Andrew R Madsen. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        setAppearance()
    }

    @IBAction func save(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        let priorityIndex = priorityControl.selectedSegmentIndex
        let priority = TaskPriority.allPriorities[priorityIndex]
        let notes = notesTextView.text
        
        if let task = task {
            // Editing existing task
            task.name = name
            task.priority = priority.rawValue
            task.notes = notes
            taskController.put(task: task)
        } else {
            let task = Task(name: name, notes: notes, priority: priority)
            taskController.put(task: task)
        }
        
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        title = task?.name ?? "Create Task"
        nameTextField.text = task?.name
        let priority: TaskPriority
        if let taskPriority = task?.priority {
            priority = TaskPriority(rawValue: taskPriority)!
        } else {
            priority = .normal
        }
        priorityControl.selectedSegmentIndex = TaskPriority.allPriorities.index(of: priority)!
        notesTextView.text = task?.notes
    }
    
    private func setAppearance() {
        
        view.backgroundColor = AppearanceHelper.beige
        
        nameTextField.font = AppearanceHelper.styleFont(with: .body, pointSize: 25)
        notesTextView.font = AppearanceHelper.styleFont(with: .body, pointSize: 25)
        priorityControl.setTitleTextAttributes([.font: UIFont(name: "Damai Kpk Polri", size: 25)!], for: .normal)
        
        nameTextField.textColor = .darkGray
        notesTextView.textColor = .darkGray
        
        nameTextField.backgroundColor = AppearanceHelper.beige
        notesTextView.backgroundColor = AppearanceHelper.beige
        
        nameTextField.borderStyle = .none
        
        nameLabel.font = AppearanceHelper.styleFont(with: .caption1, pointSize: 20)
        notesLabel.font = AppearanceHelper.styleFont(with: .caption1, pointSize: 20)
        priorityLabel.font = AppearanceHelper.styleFont(with: .caption1, pointSize: 20)
        
        nameLabel.textColor = AppearanceHelper.citron
        notesLabel.textColor = AppearanceHelper.citron
        priorityLabel.textColor = AppearanceHelper.citron
        
        priorityControl.apportionsSegmentWidthsByContent = true
        
    }
    
    // MARK: Properties
    
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    var taskController: TaskController!

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priorityControl: UISegmentedControl!
    @IBOutlet var notesTextView: UITextView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
}
