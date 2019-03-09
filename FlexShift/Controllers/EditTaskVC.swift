//
//  EditTaskVC.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/12/04.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

class EditTaskVC: NewTaskVC {

    @IBOutlet weak var taskPicker: NSPopUpButton!
    @IBOutlet weak var timeRemainingHoursBox: NSTextField!
    @IBOutlet weak var timeRemainingMinutesBox: NSTextField!
    @IBOutlet weak var deleteButton: NSButton!
    
    
    
    var tasks = [Task]()
    override var task: Task? {
        didSet {
            self.populateForm()
        }
    }
    
    //MARK: - STATE VARIABLES
    var changed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Delegates
        self.timeRemainingHoursBox.delegate = self
        self.timeRemainingMinutesBox.delegate = self
        
        self.populateTaskPicker()
    }
    
    @objc func selectMenuItem(_ sender:TaskMenuItem){
        self.task = sender.task
        self.toggleButtons()
    }
    
    func populateTaskPicker(){
        self.taskPicker.removeAllItems()
        for task in GlobalDataManager.allTasks {
            let taskItem = TaskMenuItem(title: task.title, action:#selector(self.selectMenuItem(_:)), task: task, keyEquivalent: "", accessory:false)
            taskItem.target = self
            self.taskPicker.menu?.addItem(taskItem)
        }
        if let item = self.taskPicker.selectedItem as? TaskMenuItem {
            self.selectMenuItem(item)
        }
        if self.taskPicker.numberOfItems < 1 {
            self.clearForm()
        }
        self.toggleButtons()
    }
    
    override func populateIntervalPicker() {
        super.populateIntervalPicker()
        self.startDatePicker.action = #selector(self.intervalChanged)
    }
    
    override func intervalChanged() {
        print("interval changed")
        self.changed = true
        self.toggleButtons()
    }
    
    override func populateForm(){
       
        guard let task = self.task else {return}
        self.titleBox.stringValue = task.title
        self.hourBox.stringValue = String(task.intervalDuration.hours())
        self.minuteBox.stringValue = String(task.intervalDuration.minutes())
        self.intervalPopup.selectItem(at: task.frequency.rawValue)
        self.startDatePicker.dateValue = task.lastRolledOver
        print("last rollover \(task.lastRolledOver) picker \(startDatePicker.dateValue)")
        self.timeRemainingHoursBox.stringValue = String(task.hoursLeft)
        self.timeRemainingMinutesBox.stringValue = String(task.minutesLeft)
    }
    
    @IBAction func testPressed(_ sender: Any) {
        
        self.startDatePicker.dateValue = self.task!.lastRolledOver.steppedUp(by: 2, forFrequency: .daily)
        print("last rollover \(self.task!.lastRolledOver) picker \(startDatePicker.dateValue)")
    }
    
    func clearForm(){
        self.titleBox.stringValue = ""
        self.hourBox.stringValue = ""
        self.minuteBox.stringValue = ""
        self.timeRemainingHoursBox.stringValue = ""
        self.timeRemainingMinutesBox.stringValue = ""
    }
    
    override func toggleButtons() {
        self.saveButton.isEnabled = self.formFilledOut && self.changed && self.taskPicker.selectedItem as? TaskMenuItem != nil
        self.deleteButton.isEnabled = self.taskPicker.selectedItem as? TaskMenuItem != nil
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        self.changed = true
        super.controlTextDidChange(obj)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        guard let task = self.task else {return}
        if Conveniences().userDidConfirm(title: "Delete Task?", message: "No baaaaaacksies♬"){
            if Prefs.CurrentTaskID == task.id {Prefs.CurrentTaskID = ""}
            (NSApplication.shared.delegate as! AppDelegate).taskMenu.removeTask(withID: task.id)
            GlobalDataManager.delete(object: task)
           
            DispatchQueue.main.async {
                self.populateTaskPicker()
                (NSApplication.shared.delegate as! AppDelegate).fullRefresh()
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let task = self.task else {return}
        self.startDatePicker.dateValue = task.lastRolledOver
        do {
            try GlobalDataManager.realm.write {
                self.recordTaskData()
                task.timeRemaining = self.hoursMinutesToSeconds(hours: self.timeRemainingHoursBox.stringValue, minutes: self.timeRemainingMinutesBox.stringValue)
                print("time remaining = \(task.timeRemaining)")
                
                self.changed = false
                self.toggleButtons()
            }
        } catch let error {
            Conveniences().presentErrorAlert(withTitle: "Error Saving", message: error.localizedDescription)
        }
        
        (NSApplication.shared.delegate as! AppDelegate).fullRefresh()
    }
    
    override func viewDidDisappear() {
        
    }

}
