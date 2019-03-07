//
//  Fonts.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/11/30.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Foundation
import Cocoa

class Fonts:NSObject {
    static var PrimaryRegular:NSFont{
        return NSFont(name: "Nunito-Regular", size: 12)!
    }
    
    static var PrimaryBold:NSFont{
        return NSFont(name: "Nunito-Bold", size: 12)!
    }
    
    static var PrimaryItalic:NSFont{
        return NSFont(name: "Nunito-Italic", size: 12)!
    }
    
    static var PrimarySemiBold:NSFont{
        return NSFont(name: "Nunito-SemiBold", size: 12)!
    }
    
    //MARK: - =====SPECIFIC FONTS=====
    
    //MARK: - == MAIN WINDOW ==
   static var MainTimer:NSFont{
        return NSFont(descriptor: Fonts.PrimaryBold.fontDescriptor, size: 40)!
    }
    
    static var TimerTitle:NSFont{
        return NSFont(descriptor: Fonts.PrimaryItalic.fontDescriptor, size: 30)!
    }
    
    //MARK: - == ALERTS ==
    static var AlertTitle:NSFont{
        return NSFont(descriptor: Fonts.PrimaryBold.fontDescriptor, size: 20)!
        
    }
    static var AlertMessage:NSFont{
        return NSFont(descriptor: Fonts.PrimaryRegular.fontDescriptor, size: 15)!
    }
    
}
