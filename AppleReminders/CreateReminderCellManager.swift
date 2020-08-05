//
//  CreateTodoCellManager.swift
//  AppleReminders
//
//  Created by Josh R on 3/30/20.
//  Copyright © 2020 Josh R. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

struct CreateReminderCellManager {

    //Section 0 - title, notes, url
    //todo title input cell
    //notes input cell
    //URL input cell
    
    //Section 1 - Remind me on a day
    //MARK: toggleCell - remind me on a day
    static func remindMeOnADay(for reminder: Reminder?, completion: @escaping () -> Void) -> ToggleTVCell {
        //realm todo object unmanaged there doesn't need to be in a write transaction
        let toggleCell = ToggleTVCell()
        toggleCell.setupToggleTVCell(with: "Remind me on a day", isSwitchOn: reminder?.isRemindOnADay ?? false)
        toggleCell.switchToggleAction = { _ in
            if toggleCell.switchToggle.isOn {
                reminder?.dueDate = toggleCell.switchToggle.isOn ? reminder?.dueDate ?? Date() : nil
            } else {
                reminder?.removeDueDate()
            }
            
            completion()
        }
        return toggleCell
    }
        
    //MARK: alarm value1 cell - if isRemindOnDay
    static func alarmCell(for reminder: Reminder?, isDatePickerVisible: Bool) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1 , reuseIdentifier: nil)
        cell.contentView.backgroundColor = .secondarySystemGroupedBackground
        cell.textLabel?.text = isDatePickerVisible ? reminder?.formatDueDateAsString() : "Alarm"
        cell.detailTextLabel?.text = isDatePickerVisible ? "" : reminder?.formatDueDateAsString()
        cell.textLabel?.textColor = isDatePickerVisible ? .systemBlue : .label
        
        return cell
    }
    
    //MARK: DatePickerCell
    static func datePickerCell(for reminder: Reminder?, completion: @escaping () -> Void) -> DatePickerTVCell {
        let cell = DatePickerTVCell()
        cell.datePicker.datePickerMode = reminder?.isTimeDueDate ?? false ? .dateAndTime : .date
        cell.datePicker.date = reminder?.dueDate ?? Date()
        cell.passDate = { date in
            reminder?.dueDate = date
            completion()
        }
        
        return cell
    }
    
    //MARK: toggleCell - remind me at a time
    static func remindMeAtATime(for reminder: Reminder?, completion: @escaping () -> Void) -> ToggleTVCell {
        //realm todo object unmanaged there doesn't need to be in a write transaction
        let toggleCell = ToggleTVCell()
        toggleCell.setupToggleTVCell(with: "Remind me at a time", isSwitchOn: reminder?.isTimeDueDate ?? false ? true : false)
        toggleCell.switchToggleAction = { _ in
            reminder?.isTimeDueDate = toggleCell.switchToggle.isOn ? true : false
            
            completion()
        }
        return toggleCell
    }
    
    //MARK: value1 cell - repeat
    static func repeatReminder(for reminder: Reminder?) -> UITableViewCell {
        let repeatCell = UITableViewCell(style: .value1 , reuseIdentifier: nil)
        repeatCell.textLabel?.text = "Repeat"
        repeatCell.detailTextLabel?.text = reminder?.frequency ?? "Never"
        repeatCell.contentView.backgroundColor = .secondarySystemGroupedBackground
        
        return repeatCell
    }
    
    //MARK: value1 cell - END repeat
    static func endRepeatReminder(for reminder: Reminder?) -> UITableViewCell {
        let repeatCell = UITableViewCell(style: .value1 , reuseIdentifier: nil)
        repeatCell.textLabel?.text = "End Repeat"
        repeatCell.detailTextLabel?.text = reminder?.repeatEndDate?.formatDateDayEMddYYTime() ?? "Never"
        repeatCell.contentView.backgroundColor = .secondarySystemGroupedBackground
        
        return repeatCell
    }
    
    //Section 2 - Remind me at a location
    //MARK: toggleCell - remind me at a location
    static func location(for reminder: Reminder?, completion: @escaping () -> Void) ->ToggleTVCell {
        //realm todo object unmanaged there doesn't need to be in a write transaction
        let toggleCell = ToggleTVCell()
        toggleCell.setupToggleTVCell(with: "Remind me at a location", isSwitchOn: reminder?.isLocationReminder ?? false)
        toggleCell.switchToggleAction = { _ in
            reminder?.atLocationLat.value = toggleCell.switchToggle.isOn ? 0.0 : nil
            reminder?.atLocationLong.value = toggleCell.switchToggle.isOn ? 0.0 : nil
            
            completion()
        }
        return toggleCell
    }
    
    //subTitleCell
    //NOTE: leave config in VC
    
    //Section 3 - Remind me when messaging
    //MARK: toggleCell - Remind me when messaging
    static func messaging(for reminder: Reminder?, completion: @escaping () -> Void) -> ToggleTVCell {
        let toggleCell = ToggleTVCell()
        toggleCell.descriptionLbl.text = "Remind me when messaging"
        toggleCell.switchToggle.isOn = reminder!.contactID.count > 0 ? true : false
        toggleCell.switchToggleAction = { _ in
            //            isSelectedContactCellVisible = toggleCell.switchToggle.isOn
            reminder?.contactID = toggleCell.switchToggle.isOn ? "TEMP" : ""
            completion()
        }
         return toggleCell
    }
    
    //ReminderContactTVCell
    static func contact(for reminder: Reminder?) -> UITableViewCell {
        if reminder!.isContactAssigned {
            let contactCell = ReminderContactTVCell()
            contactCell.passsedContact = reminder?.retrieveContact
            return contactCell
        } else {
            let cell = UITableViewCell(style: .value1 , reuseIdentifier: nil)
            cell.textLabel?.text = "Choose Person"
            cell.textLabel?.textColor = .systemBlue
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = .secondarySystemGroupedBackground
            return cell
        }
    }
    
    
    
    //Section 4 - Flagged, Priority, and List
    //MARK: toggleCell - Flagged
    
    //value1 - priority
    //value1 - list
    
    //Section 5 - Subtasks
    //value1
    
    //Section 6 - Add image
    //value1
    
}




















