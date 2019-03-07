//
//  Extensions.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/11/30.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Foundation
import Cocoa


//MARK: - =============UICOLOR=====================
extension NSColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

//MARK: - =============DATE=====================
extension Date {
    func components()-> [Int] {
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        let weekday = calendar.component(.weekday, from: self)
       
        return [year, month, day, hour, minute, weekday]
    }
    
    func toString()-> String{
        let formatter = DateFormatter()
        formatter.dateFormat =  "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
    
    func steppedUp(by number:Int, forFrequency frequency:RolloverFrequency)-> Date {
        let comp:Calendar.Component = frequency == .monthly ? .month : .day
        let val = frequency == .weekly ? 7 : 1
        let cal = NSCalendar.current
        return cal.date(byAdding: comp, value: (val * number), to: self)!
    }
    
    func startOf(interval:RolloverFrequency)-> Date {
        var date = self
        let cal = NSCalendar.current
        
        if interval == .weekly {
            let sunday = DateComponents(calendar:cal, weekday:1)
            date = cal.nextDate(after: date, matching: sunday, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)!
        }
        
        var components = cal.dateComponents([.day, .hour, .minute, .year, .month, .timeZone, .weekday], from: date)
        components.hour = 0
        components.minute = 0
        if interval == .monthly {
            components.day = 1
        }
        return cal.date(from: components)!
    }
    
}


//MARK: - =============Int=====================

extension Int {
    func doubleDigitString()->String{
        
        if self < 10 {
            return String(format:"%02d", self)
        }
        return String(self)
    }
    
    func hours()->Int {
        return self / 3600
    }
    
    func minutes()->Int {
        return (self % 3600) / 60
    }
    
}

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}
