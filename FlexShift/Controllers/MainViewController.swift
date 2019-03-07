//
//  ViewController.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/11/30.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, SheetVCDelegate {
    
    //MARK: - ===== IBOUTLETS =====

    //MARK: - == TIMER LABELS  ==
    @IBOutlet weak var hourLabel: NSTextField!
    @IBOutlet weak var minuteLabel: NSTextField!
    @IBOutlet weak var secondLabel: NSTextField!
    
    @IBOutlet weak var colonLabel1: NSTextField!
    @IBOutlet weak var colonLabel2: NSTextField!
    
    //MARK: - == OTHER LABELS  ==
    @IBOutlet weak var titleLabel: NSTextField!
    
    
    //MARK: - == BUTTONS  ==
    @IBOutlet weak var startStopButton: NSButton!
    
    
    
    //MARK - ===== VARIABLES ======
    
    //MARK - == OBJECTS ==
    var task:Task? {
        didSet {
            self.taskLoaded()
        }
    }
    var timer = Timer()
    
    //MARK - == STATE VARIABLES ==
    var timerRunning = false
    
    
    
    //MARK: - ======= SETUP ======
    
    //MARK: - == INITIALIZATION ==
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: UpdateUI
        self.setFonts()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.loadTask()
    }
    
    
    
    //MARK: - == UI SETUP==
    func setFonts(){
        for label in [self.hourLabel, self.minuteLabel, self.secondLabel, self.colonLabel1, self.colonLabel2] {
            label?.font = Fonts.MainTimer
        }
        
        self.titleLabel.font = Fonts.TimerTitle
    }
    
    func toggleButtons(){
        self.startStopButton.title = self.timerRunning ? "Stop" : "Start"
        self.startStopButton.isEnabled = self.task != nil
    }
    
    func updateLabels(){
        self.titleLabel.stringValue = self.task?.title ?? "No Task"
    }
    
    func displayTime(){
        self.hourLabel.stringValue = "\(self.task?.hoursLeft ?? 00)"
        self.minuteLabel?.stringValue = "\(self.task?.minutesLeft ?? 00)"
        self.secondLabel.stringValue = "\(self.task?.secondsLeft ?? 00)"
    }
    
    
    
    func loadTask() {
        if let t = GlobalDataManager.task(withId: Prefs.CurrentTaskID) {
            self.task = t
        } else {
            Conveniences().presentVCAsSheet(id: .new, sender: self)
        }
    }
    
    func taskLoaded(){
        self.displayTime()
        self.toggleButtons()
        self.updateLabels()
    }
    
    
    //MARK: - ====== TIMER FUNCTIONS ======
    
    func startTimer(){
        self.timerRunning = true
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }

    
    @objc func updateTimer() {
       
        self.task?.countDown()
        if let task = self.task, task.timeRemaining < 1 {
            self.stopTimer()
        }
        self.displayTime()
    }
    
    func stopTimer(){
        self.timer.invalidate()
        self.timerRunning = false
    }
    
    
    @IBAction func startStopPressed(_ sender: Any) {
        if !self.timerRunning {
            self.startTimer()
        } else {
            self.stopTimer()
        }
        self.toggleButtons()
    }
    

    //MARK: - ====== NAVIGATION ======
    func returnFromSheetVC(sender: SheetVC) {
        self.loadTask()
    }

}

