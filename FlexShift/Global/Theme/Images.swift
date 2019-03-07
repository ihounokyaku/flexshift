//
//  Images.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/12/02.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa

class Images: NSObject {

    static var StatusBarButton:NSImage {
        return NSImage().named("clock-1")
    }
}


extension NSImage {
    func named(_ name:String)-> NSImage{
        return NSImage(named:name) ?? NSImage(named:"noImage")!
    }
}
