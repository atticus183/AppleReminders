//
//  Model.swift
//  AppleReminders
//
//  Created by Josh R on 1/24/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import UIKit
import Contacts
import SwiftDate


struct SampleData {
    //MARK: Sample List data - Realm model added
//    static func generateTestData() -> [ExpandableCVCellModel] {
//        var cellModels = [ExpandableCVCellModel]()
//        let realm = MyRealm.getConfig()
//        let accounts = realm?.objects(ReminderAccount.self)
//        
//        for account in accounts! {
//            var listCellModels = [ExpandableCVCellModel]()
//            if account.lists.count > 0 {
//                for list in account.lists {
//                    let cellModel = ExpandableCVCellModel(thisItem: list, cellType: .list, subItems: [], isExpanded: nil)
//                    listCellModels.append(cellModel)
//                }
//            }
//            
//            let cellModel = ExpandableCVCellModel(thisItem: account, cellType: .account, subItems: listCellModels, isExpanded: account.isExpanded)
//            cellModels.append(cellModel)
//        }
//        
//        return cellModels
//    }
    
//    static func generateSampleData() -> [ExpandableCVCellModel] {
//        var cellModels = [ExpandableCVCellModel]()
//        let realm = MyRealm.getConfig()
//        let accounts = realm?.objects(ReminderAccount.self)
//
//        //Type
//        for type in ReminderType.allCases {
//            let cellModel = ExpandableCVCellModel(thisItem: type, cellType: .type, subItems: [], isExpanded: nil)
//            cellModels.append(cellModel)
//        }
//
//        //Account
//        for account in accounts! {
//            var listCellModels = [ExpandableCVCellModel]()
//            if account.lists.count > 0 {
//                for list in account.lists {
//                    let cellModel = ExpandableCVCellModel(thisItem: list, cellType: .list, subItems: [], isExpanded: account.isExpanded)
//                    listCellModels.append(cellModel)
//                }
//            }
//
//            let cellModel = ExpandableCVCellModel(thisItem: account, cellType: .account, subItems: listCellModels, isExpanded: account.isExpanded)
//            cellModels.append(cellModel)
//        }
//
//        return cellModels
//    }
    
    static func generateCreateListModel() -> [CreateListModel] {
        var createListModel = [CreateListModel]()
        
        //Create color icons
        for colorDict in CustomColors.systemColors {
            let color = CreateListModel(colorHEX: colorDict, iconName: nil, iconType: nil, cellType: .color)
            createListModel.append(color)
        }
        
        //Create icon icons
        for icon in IconsData.icons {
            let iconObject = CreateListModel(colorHEX: "", iconName: icon.iconName, iconType: icon.iconType, cellType: .icon)
            createListModel.append(iconObject)
        }
        
        return createListModel
    }
    
}


struct SampleRealmData {
    //MARK: Master Create Realm Data method
    static func createTestRealmData() {
//        SampleRealmData.createDefaultAccount()
        SampleRealmData.createLists()
    }
    
    static func addRemindersToCurrentModel() {
        let realm = MyRealm.getConfig()
        let reminders = ["Buy milk", "Pick up kid from daycare", "MOA", "Testing", "Go to Store", "Pay milk money"]
        
        try! realm?.write {
            for list in realm!.objects(ReminderList.self) {
                for (index, reminder) in reminders.enumerated() {
                    let newReminder = Reminder()
                    newReminder.name = reminder
                    newReminder.inList = list
                    newReminder.sortIndex = index
                    newReminder.dueDate = Dates.generateRandomDate(between: Date() - 60.days, and: Date() + 60.days)
                    
                    list.reminders.append(newReminder)
                }
            }
        }
    }
    

    static func createLists() {
        let realm = MyRealm.getConfig()
        
        let startingLists = ["General", "1/11", "2/11", "MOA", "Vacation", "Birthday", "Christmas", "Reminders"]
        
        try! realm?.write {
            for (index, listItem) in startingLists.enumerated() {
                let list = ReminderList()
                list.name = listItem
                list.listColor = CustomColors.generateRandomSystemColor() //Generate a random color from CustomColors.systemColors
                list.sortIndex = index
                
                realm?.add(list)
            }
        }
    }
    
    //Only need if current data doesn't have due dates.  Call in ViewDidLoad from MainVC
    static func generateRandomDueDatesInCurrentRealm() {
        let realm = MyRealm.getConfig()
        
        guard let Reminders = realm?.objects(Reminder.self) else { return }
        
        try! realm?.write {
            for reminder in Reminders {
                reminder.dueDate = Dates.generateRandomDate(between: Date.init(month: 1, day: 1, year: 2020), and: Date.init(month: 5, day: 31, year: 2020))
            }
        }
    }
}

