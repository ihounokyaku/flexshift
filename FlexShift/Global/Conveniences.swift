//
//  Conveniences.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/11/30.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

enum VCIdentifier:String{
    case main = "MainVC"
    case new = "NewTaskVC"
    case options = "OptionsVC"
}

class Conveniences: NSObject {

    //MARK: - ===== DATE =====
    func date(fromString string:String)-> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd,HH:mm"
        return dateFormatter.date(from:string)!
    }
    
    
    //MARK: - ===== ALERTS =====
    func presentErrorAlert(withTitle title:String, message:String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    //MARK: - ===== NAVIGATION =====
    func presentVCAsSheet(id:VCIdentifier, sender:NSViewController) {
        guard let controller = Storyboard.instantiateController(withIdentifier:id.rawValue) as? SheetVC else {return}
        if let delegate = sender as? SheetVCDelegate {
            controller.delegate = delegate
        }
        sender.presentAsSheet(controller)
    }
    
    func presentWindow(withVC id:VCIdentifier){
        (NSApplication.shared.delegate as! AppDelegate).timerController.stopTimer()
        
        let controller = Storyboard.instantiateController(withIdentifier: id.rawValue) as! NSViewController
        
        guard MainWindow?.isVisible != true else {return}
        
        MainWindow = NSWindow(contentViewController: controller)
        MainWindow?.makeKeyAndOrderFront((NSApplication.shared.delegate as! AppDelegate))
        let vc = NSWindowController(window: MainWindow)
        (NSApplication.shared.delegate as! AppDelegate).enableDisableMenuItems(enable: false)
        vc.showWindow((NSApplication.shared.delegate as! AppDelegate))
    }
    
    func userDidConfirm(title:String, message:String)-> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "Do it anyway")
        alert.addButton(withTitle: "Cancel")
        
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return true
        }
        return false
    }

}
