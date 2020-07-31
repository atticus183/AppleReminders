//
//  AddListToGroupTVC.swift
//  AppleReminders
//
//  Created by Josh R on 7/18/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import UIKit
import RealmSwift

protocol SendSelectedListsDelegate: class {
    func pass(lists: [ReminderList])
}

class AddListToGroupTVC: UITableViewController {
    
    var selectedLists = [ReminderList]()
    
    weak var delegate: SendSelectedListsDelegate?
    
    lazy var createGroupDatasource = CreateGroupDatasource()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Include"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CreateGroupDatasource.cellID)
        self.tableView.register(AddListToGroupHeaderView.self, forHeaderFooterViewReuseIdentifier: AddListToGroupHeaderView.reuseIdentifier)
        tableView.setEditing(true, animated: false)
        tableView.tableFooterView = UIView()
        
        createGroupDatasource.tableView = tableView
        createGroupDatasource.selectedLists = selectedLists
        createGroupDatasource.setupDatasource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        addSelectedLists()
    }
    
    private func addSelectedLists() {
        guard let snapShot = createGroupDatasource.groupDiffableDatasource?.snapshot() else { return }
        selectedLists.removeAll()
        snapShot.itemIdentifiers(inSection: .include).forEach({ selectedLists.append($0) })
        
        delegate?.pass(lists: selectedLists)
        
        print("Selected lists: \(selectedLists.count)")
    }
    
    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let allLists = availableLists else { return 3 }
//
//        switch section {
//        case 0:
//            return selectedLists.count == 0 ? allLists.count : selectedLists.count
//        case 1:
//            return selectedLists.count == 0 ? 0 : selectedLists.count
//        default:
//            return 0
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
//
//        let availableList = availableLists?[indexPath.row]
//        var listName: String
//
//        switch indexPath.section {
//        case 0:
//            let selectedList = selectedLists.count == 0 ? nil : selectedLists[indexPath.row]
//            listName = selectedLists.count == 0 ? availableList?.name ?? "" : selectedList?.name ?? ""
//        case 1:
//            listName = availableList?.name ?? ""
//        default:
//            return cell
//        }
//
//        cell.textLabel?.text = listName
//
//        return cell
//    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AddListToGroupHeaderView.reuseIdentifier) as! AddListToGroupHeaderView
//
//        switch section {
//        case 0:
//            headerView.title = selectedLists.count == 0 ? "MORE LISTS" : "INCLUDE"
//        case 1:
//            headerView.title = selectedLists.count == 0 ? "" : "MORE LISTS"
//        default:
//            break
//        }
//
//        return headerView
//    }
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AddListToGroupHeaderView.height
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard let section = createGroupDatasource.groupDiffableDatasource?.snapshot().sectionIdentifiers[indexPath.section] else { return .none }
        
        switch section {
        case .include:
            return .delete
        case .available:
            return .insert
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

}
