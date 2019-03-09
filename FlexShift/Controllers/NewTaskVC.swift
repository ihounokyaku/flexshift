//
//  NewTaskVC.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/12/01.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

class NewTaskVC: NSViewController, NSTextFieldDelegate {
    //MARK: - ====== IBOUTLETS ======
    
    //MARK: - ==Blanks==
    @IBOutlet weak var titleBox: NSTextField!
    @IBOutlet weak var hourBox: NSTextField!
    @IBOutlet weak var minuteBox: NSTextField!
    
    //MARK: - ==Pickers==
    @IBOutlet weak var intervalPopup: NSPopUpButton!
    @IBOutlet weak var startDatePicker: NSDatePicker!
    
    //MARK: - ==Buttons==
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    
    //MARK: - ====== VARIABLES ======
    
    var textFields:[NSTextField]!
    var task:Task?
    
    //MARK: - == STATE VARIABLES ==
    var formFilledOut:Bool {
        get {
            for item in self.textFields {
                if item.stringValue == "" {
                    return false
                }
            }
            return true
        }
    }
    
    //MARK: - ====== SETUP =====
    
    //MARK: - == INITIALIZATION ==
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Set Variables
        self.textFields = [self.titleBox, self.hourBox, self.minuteBox]
        
        //MARK: Set Delegates
        for field in self.textFields {
            field.delegate = self
        }
        
        //MARK: Update  UI
        self.toggleButtons()
        
        
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.populateIntervalPicker()
    }
    
    //MARK: - == UI UPDATES ==
    func toggleButtons(){
        self.saveButton.isEnabled = self.formFilledOut
    }
    
    func populateForm(){
        self.startDatePicker.dateValue = Date().startOf(interval: RolloverFrequency(rawValue: self.intervalPopup.indexOfSelectedItem)!)
    }
    
    
    //MARK: - ====== DATA ENTRY ======
    
    func controlTextDidChange(_ obj: Notification) {
        self.toggleButtons()
    }
    
    func populateIntervalPicker(){
        for item in self.intervalPopup.menu!.items {
            item.action = #selector(self.intervalChanged)
            item.target = self
        }
    }
    
    @objc func intervalChanged(){
        self.populateForm()
    }
    
    //MARK: - ==SAVE/CANCEL ==
    @IBAction func savePressed(_ sender: Any) {
        self.saveNewTask()
    }
    
    func saveNewTask(){
        self.task = Task()
        self.recordTaskData()
        Prefs.CurrentTaskID = self.task!.id
        GlobalDataManager.addObject(object: self.task!)
        DispatchQueue.main.async {
            (NSApplication.shared.delegate as! AppDelegate).fullRefresh()
        }
        
        self.view.window?.close()
    }
    
    func recordTaskData(){
        self.task!.id = self.titleBox.stringValue + "\(Date().timeIntervalSince1970)"
        self.task!.title = self.titleBox.stringValue
        self.task!.rolloverFrequency = self.intervalPopup.indexOfSelectedItem
        self.task!.intervalDuration = self.hoursMinutesToSeconds(hours: self.hourBox.stringValue, minutes: self.minuteBox.stringValue)
        self.task!.timeRemaining = self.task!.intervalDuration
        self.task!.mostRecentDuration = self.task!.intervalDuration
        self.task!.nextRollover = self.startDatePicker.dateValue.steppedUp(by: 1, forFrequency: RolloverFrequency(rawValue: self.intervalPopup.indexOfSelectedItem)!)
        self.task!.lastRolledOver = self.startDatePicker.dateValue
        print("setting initial rollover for \(self.task!.lastRolledOver) and picker \(self.startDatePicker.dateValue)")
    }
    
    func hoursMinutesToSeconds(hours:String, minutes:String)-> Int{
        return (Int(hours)! * 3600) + (Int(minutes)! * 60)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.view.window?.close()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        (NSApplication.shared.delegate as! AppDelegate).enableDisableMenuItems(enable: true)
    }
    
}
