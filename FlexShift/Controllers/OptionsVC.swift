//
//  OptionsVC.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/12/05.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

class OptionsVC: NSViewController {
    @IBOutlet weak var startAtLaunchCheckBox: NSButton!
    
    override func viewDidLoad() {
        self.startAtLaunchCheckBox.state = Prefs.LaunchOnStartup ? .on : .off
        print("tabVcloading3")
        super.viewDidLoad()
        print("tabVcloading4")
        // Do view setup here.
    }
    @IBAction func checkboxChecked(_ sender: Any) {
        Prefs.LaunchOnStartup = self.startAtLaunchCheckBox.state == .on
    }
    
}
