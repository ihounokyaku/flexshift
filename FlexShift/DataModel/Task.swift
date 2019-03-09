//
//  Movie.swift
//  FilmSwipe
//
//  Created by Dylan Southard on 2018/06/10.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Foundation
import RealmSwift

enum RolloverFrequency:Int {
    case daily = 0
    case weekly = 1
    case monthly = 2
}

class Task : Object {
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var timeRemaining = 0
    @objc dynamic var rolloverFrequency = 0
    @objc dynamic var intervalDuration = 0
    @objc dynamic var mostRecentDuration = 0
    @objc dynamic var nextRolloverString = "2018-05-06 00:00"
    @objc dynamic var lastRolloverString = "2018-05-05 00:00"
    @objc dynamic var lastRolloverDate = Date()
    @objc dynamic var nextRolloverDate = Date()
    
    var lastRolledOver:Date {
        get {
            return Prefs.IgnoreTimezones ? Conveniences().date(fromString: self.lastRolloverString) : self.lastRolloverDate
        }
        set {
            self.lastRolloverDate = newValue
            self.lastRolloverString = newValue.toString()
        }
    }
    
    
    var nextRollover:Date {
        get {
            return Prefs.IgnoreTimezones ? Conveniences().date(fromString: self.nextRolloverString) : self.nextRolloverDate
        }
        set {
            self.nextRolloverDate = newValue
            self.nextRolloverString = newValue.toString()
        }
    }
    
    var frequency:RolloverFrequency {
        get {
            switch self.rolloverFrequency {
            case 1:
                return .weekly
            case 3:
                return .monthly
            default:
                return .daily
            }
        }
        set {
            self.rolloverFrequency = newValue.rawValue
        }
    }
    
    
    
    
    //MARK: - == REMAINING TIME  ==
    var hoursLeft:Int {
        get {
            return self.timeRemaining.hours()
        }
        set {
            let timeAdded = (newValue - self.hoursLeft) * 3600
            self.addTime(amount: timeAdded)
        }
    }
    
    var minutesLeft:Int {
        get {
            return self.timeRemaining.minutes()
        }
        set {
            let timeAdded = (newValue - self.minutesLeft) * 60
            self.addTime(amount: timeAdded)
        }
    }
    
    var secondsLeft:Int {
        get {
            return (self.timeRemaining % 3600) % 60
        }
        set {
            let timeAdded = newValue - self.secondsLeft
            self.addTime(amount: timeAdded)
        }
    }
    
    var timeString:String {
        var pref = ""
        let hours = self.hoursLeft
        let min = self.minutesLeft
        let sec = self.secondsLeft
        
        if hours < 0 || min < 0 || sec < 0 {
            pref = "-"
        }
        
        return pref + abs(self.hoursLeft).doubleDigitString() + ":" + abs(self.minutesLeft).doubleDigitString() + ":" + abs(self.secondsLeft).doubleDigitString()
    }
    
    
    
    func addTime(amount:Int) {
        do {
            try GlobalDataManager.realm.write {
                self.timeRemaining += amount
            }
        } catch let error {
            Conveniences().presentErrorAlert(withTitle: "Update Error", message: error.localizedDescription)
        }
    }
    
    //MARK: - == FUNCTIONS  ==
    
    func countDown() {
        do {
            try GlobalDataManager.realm.write {
                self.timeRemaining -= 1
            }
        } catch let error {
            Conveniences().presentErrorAlert(withTitle: "Countdown Error", message: error.localizedDescription)
        }
    }
    
    //MARK: Rollover
    var timer:Timer?
    
    @objc func rollover() {
        print("rolling over next rollover for \(self.title) is \(self.nextRollover.toString())")
        let now = Date()
        if self.nextRollover <= now {
        while self.nextRollover <= now {
            print("doing that rollover next rollover for \(self.title) is \(self.nextRollover.toString())")
            do {
                try GlobalDataManager.realm.write {
                    self.timeRemaining += self.intervalDuration
                    print("rollover interval duration is \(self.intervalDuration)")
                    self.lastRolledOver = self.nextRollover
                    self.nextRollover = self.nextRollover.steppedUp(by: 1, forFrequency: self.frequency)
                    self.mostRecentDuration = self.timeRemaining
                }
            } catch let error {
                Conveniences().presentErrorAlert(withTitle: "Rollover Error", message: error.localizedDescription)
            }
        }
            DispatchQueue.main.async {
                (NSApplication.shared.delegate as! AppDelegate).taskMenu.construct()
                if Prefs.CurrentTaskID == self.id {
                    (NSApplication.shared.delegate as! AppDelegate).display(time: self.timeString)
                }
            }
            
        }
        print("rolled over next rollover for \(self.title) is \(self.nextRollover.toString()) total is \(self.timeString)")
        self.setRollover()
    }
    
    func setRollover(){
        print("setting rollover next rollover for \(self.title) is \(self.nextRollover.toString())")
        self.timer?.invalidate()
        self.timer = Timer(fireAt: self.nextRollover, interval: 0, target: self, selector: #selector(self.rollover), userInfo: nil, repeats: false)
        RunLoop.main.add(timer!, forMode: .common)
    }
}
