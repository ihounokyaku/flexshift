//
//  TaskSubmenu.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/12/02.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

class TaskSubmenu: NSMenu {
    override init(title: String) {
        super.init(title: title)
        self.construct()
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.construct()
    }
    
    var taskItems = [TaskMenuItem]()
    
    
    func construct(){
        for taskItem in self.taskItems {taskItem.task.timer?.invalidate()}
        self.taskItems.removeAll()
        self.removeAllItems()
        self.addItem(NSMenuItem(title: "New Task", action: #selector(AppDelegate.launchNewTaskWindow), keyEquivalent: ""))
        self.addItem(NSMenuItem.separator())
        
        for task in GlobalDataManager.allTasks {
            let item = TaskMenuItem(title: task.title + " (\(task.timeString))", action: #selector(AppDelegate.taskSelected(_:)), task: task, keyEquivalent:"")
            self.addItem(item)
            self.taskItems.append(item)
        }
    }
    
    func refreshTimes() {
        for item in self.taskItems {item.title = item.task.title + " (\(item.task.timeString))"}
    }
    
    func refreshChecks() {
        for item in self.taskItems {item.updateAccessory()}
        
    }
    
    func removeTask(withID id:String){
        let taskIDs = self.taskItems.map({return $0.task.id})
        if taskIDs.contains(id) {
            self.taskItems.remove(at: taskIDs.index(of:id)!)
        }
    }
}
