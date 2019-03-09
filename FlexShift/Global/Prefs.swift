//
//  Prefs.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/11/30.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa


class Prefs: NSObject {
    //MARK: - ==CURRENT SESSION==
    static var DataManager:DataManager? 
    
    //MARK: - ==SAVED PREFS==
    static var CurrentTaskID:String {
        get {
            return UserDefaults.standard.value(forKey: "currentTaskID") as? String ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentTaskID")
        }
    }
    
    static var LaunchOnStartup:Bool {
        get {
            return UserDefaults.standard.value(forKey: "launchOnStartup") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "launchOnStartup")
            (NSApplication.shared.delegate as! AppDelegate).setLaunch()
        }
    }
    
    static var IgnoreTimezones:Bool {
        get {
            return UserDefaults.standard.value(forKey: "ignoreTimezones") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ignoreTimezones")
        }
    }
}
