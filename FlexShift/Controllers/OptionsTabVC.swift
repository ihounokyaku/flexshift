//
//  OptionsTabVC.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/12/05.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

class OptionsTabVC: NSTabViewController {

    
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        (NSApplication.shared.delegate as! AppDelegate).enableDisableMenuItems(enable: true)
    }
    
}
