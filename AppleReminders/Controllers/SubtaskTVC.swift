//
//  SubtaskTVC.swift
//  AppleReminders
//
//  Created by Josh R on 4/22/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit
import RealmSwift

protocol PassSubtasksDelegate: class {
    func pass(subtasks: [Reminder])
}

class SubtaskTVC: UITableViewController {
    
    let realm = MyRealm.getConfig()
    
    var parentReminder: Reminder?
    
    weak var delegate: PassSubtasksDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Subtasks"
        self.tableView.register(SubtaskCell.self, forCellReuseIdentifier: SubtaskCell.identifier)
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        var subtasks = [Reminder]()
        parentReminder?.subtasks.forEach({ subtasks.append($0) })
        delegate?.pass(subtasks: subtasks)
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If subtask count is 0, return 1 (add Reminder cell)
        guard let parentReminder = parentReminder else { return 1 }
        return parentReminder.subtasks.count + 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubtaskCell.identifier, for: indexPath) as! SubtaskCell
        
        //Last cell
        if indexPath.row == parentReminder!.subtasks.count {
            cell.configureAddReminderCell()
        } else {
            //Configure subtask cell
            let subtask = parentReminder?.subtasks[indexPath.row]
            cell.reminder = subtask
            cell.parentReminder = parentReminder
            if subtask?.name == "" {
                DispatchQueue.main.async {
                    cell.nameTxtBox.becomeFirstResponder()
                }
            }
            
            //Used when a user hits the return key.
            cell.passParentReminder = { [weak self] parentReminder in
                self?.parentReminder = parentReminder
                self?.tableView.reloadData()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Last cell
        if indexPath.row == parentReminder!.subtasks.count {
            try! realm?.write {
                let newSubtask = Reminder()
                parentReminder?.subtasks.append(newSubtask)
            }
            
            tableView.reloadData()
        } else {
           
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
