//
//  TaskMenuItem.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/12/02.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

class TaskMenuItem: NSMenuItem {
    var task:Task!
    var accessory = true
    
    init(title string: String, action selector: Selector?, task:Task, keyEquivalent charCode: String, accessory:Bool = true) {
        super.init(title: string, action: selector, keyEquivalent: charCode)
        
        self.task = task
        self.task.rollover()
        self.accessory = accessory
        self.updateAccessory()
    }
    
    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAccessory(){
        if self.accessory{
            self.state = self.task.id == Prefs.CurrentTaskID ? .on : .off
        }
    }
}
