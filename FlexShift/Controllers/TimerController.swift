//
//  TimerController.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/12/02.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

protocol TimerControllerDelegate {
    func display(time:String)
    func timerSet()
}

class TimerController: NSObject {
    var timer = Timer()
    var delegate:TimerControllerDelegate?
    var timerRunning = false
    var task:Task? {
        didSet {
            self.delegate?.timerSet()
            self.displayTimeRemaining()
        }
    }
    
    
    func startTimer(){
        self.timerRunning = true
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateTimer() {
        self.task?.countDown()
//        if let task = self.task, task.timeRemaining < 1 {
//            self.stopTimer()
//        }
        self.displayTimeRemaining()
    }
    
    func displayTimeRemaining(){
        self.delegate?.display(time: self.task?.timeString ?? "error")
    }
    
    func stopTimer(){
        self.timer.invalidate()
        self.timerRunning = false
    }
    
    func toggleRunning() {
        if self.timerRunning {
            self.stopTimer()
        } else {
            self.startTimer()
        }
    }
}


