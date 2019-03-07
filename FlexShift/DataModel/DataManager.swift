//
//  DataManager.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/11/30.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa
import RealmSwift

class DataManager: NSObject {
    
    //MARK: - ====== VARIABLES  =====
    //MARK: - == SETUP ==
    var realm = try! Realm(configuration: RealmConfig)
    
    //MARK: - == RESULTS  ==
    var allTasks:Results<Task> {
        return self.realm.objects(Task.self).sorted(byKeyPath: "title", ascending: true)
    }
    
     //MARK: - ========== CREATE ==========
    func addObject(object:Object){
        do {
            try self.realm.write {
                realm.add(object)
            }
        } catch let error {
            Conveniences().presentErrorAlert(withTitle: "Error Saving", message: error.localizedDescription)
        }
    }
    
    
    //MARK: - ========== READ ==========
    func task(withId id:String)-> Task? {
        return self.realm.objects(Task.self).filter("id == %i", id).first
    }
    
    func databaseContains(movieWithId id:String)->Bool {
        return self.task(withId: id) != nil
    }
    
    //MARK: - ========== UPDATE ==========
    
     //MARK: - ========== DELETE ==========
    func delete(object:Object){
        do {
            
            try self.realm.write {self.realm.delete(object)}
            
        } catch let error {
            Conveniences().presentErrorAlert(withTitle: "Could not delete", message: error.localizedDescription)
        }
    }
    
}
