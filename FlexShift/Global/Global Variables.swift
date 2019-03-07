//
//  Global Variables.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/11/30.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Foundation
import RealmSwift

//MARK: - ==REALM CONFIG==
var AppSupportDirectory:URL {
    let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
    let flexFolder = appSupport.appendingPathComponent("FlexShift")
    do {
        try FileManager.default.createDirectory(at: flexFolder, withIntermediateDirectories: true)
    } catch {}
    
    return flexFolder
}

var GlobalDataManager:DataManager {
    Prefs.DataManager = Prefs.DataManager ?? DataManager()
    return Prefs.DataManager!
}


var GroupRealmFolder:URL {
    get {
        return AppSupportDirectory.appendingPathComponent("FlexShift.realm")
    }
}

var RealmConfig:Realm.Configuration {
    get {
        return Realm.Configuration(fileURL: GroupRealmFolder)
    }
}

//MARK: - ==== GLOBAL POINTERS  =====

let Storyboard = NSStoryboard(name:"Main", bundle: nil)

var MainWindow:NSWindow?
