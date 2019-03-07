//
//  SheetVC.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/12/01.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

protocol SheetVCDelegate {
    func returnFromSheetVC(sender:SheetVC)
}

class SheetVC: NSViewController {

    var delegate:SheetVCDelegate?
    
    
}
