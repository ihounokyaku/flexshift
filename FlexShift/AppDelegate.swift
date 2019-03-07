//
//  AppDelegate.swift
//  FlexShift
//
//  Created by Dylan Southard on 2018/11/30.
//  Copyright © 2018 Dylan Southard. All rights reserved.
//

import Cocoa
import RealmSwift
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, TimerControllerDelegate {
    
    

    var statusItem:NSStatusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    var timerController = TimerController()
    let menu = MainMenu()
    var taskMenu = TaskSubmenu()
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //LAUNCHER STUFF
        self.setLaunch()
        self.timerController.delegate = self
        self.setFileNotifications()
        //MARK: SET STATUS BAR IMAGE
        
        
        
        print(AppSupportDirectory)
        // Insert code here to initialize your application
        do {
            _ = try Realm(configuration: RealmConfig)
        } catch {
            print("eroror with relam \(error)")
        }
        
        self.loadTask()
        self.constructMenu()
    }
    
    func setLaunch(){
        let ret = SMLoginItemSetEnabled("com.ihounokyaku.com.FlexShift" as CFString, Prefs.LaunchOnStartup)
        NSLog("\(ret)")
        let launcherAppId = "com.ihounokyaku.com.FlexShiftLauncher"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == launcherAppId }.isEmpty
        
        SMLoginItemSetEnabled(launcherAppId as CFString, Prefs.LaunchOnStartup)
        
        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher,
                                                         object: Bundle.main.bundleIdentifier!)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func startStop() {
        self.timerController.toggleRunning()
        self.updateMenuItems()
    }
    
    func constructMenu() {
        self.menu.removeAllItems()
        self.menu.startStopButton = NSMenuItem(title: self.timerController.timerRunning ? "Stop":"Start", action: #selector(AppDelegate.startStop), keyEquivalent: "")
        self.menu.addItem(self.menu.startStopButton!)
        
        let submenuButton = NSMenuItem()
        submenuButton.title = "Tasks"
        submenuButton.submenu = self.taskMenu
        self.menu.addItem(submenuButton)
        self.menu.addItem(NSMenuItem(title: "Options", action: #selector(self.lauchNewOptionsWindow), keyEquivalent: ""))
        self.menu.addItem(NSMenuItem.separator())
        self.menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        
        self.statusItem.menu = menu
        self.menu.autoenablesItems = false
        self.updateMenuItems()
    }
    
    func updateMenuItems(){
        
        self.menu.startStopButton?.isEnabled = self.timerController.task != nil
        
        self.menu.startStopButton?.title = self.timerController.timerRunning ? "Stop":"Start"
    }
    
    func enableDisableMenuItems(enable:Bool){
        for item in self.menu.items {
            item.isEnabled = enable
        }
        if enable {self.updateMenuItems()}
    }
    
    //MARK: - LOAD TIMER
    
    func timerSet() {
        self.statusItem.length = -1
        self.statusItem.button?.image = nil
    }
    
    func displayIcon(){
        self.statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        self.statusItem.button?.image = Images.StatusBarButton
        
    }
    
    func display(time: String) {
        self.statusItem.button?.title = time
        self.taskMenu.refreshTimes()
    }
    
    func loadTask() {
        if let t = GlobalDataManager.task(withId: Prefs.CurrentTaskID) {self.timerController.task = t
        } else {
            self.timerController.task = nil
            self.displayIcon()
        }
        self.updateMenuItems()
    }
    
    @objc func launchNewTaskWindow(){
        Conveniences().presentWindow(withVC: .new)
        NSApp.activate(ignoringOtherApps: true)
        
    }
    
    @objc func lauchNewOptionsWindow(){
        Conveniences().presentWindow(withVC: .options)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func taskSelected(_ sender:TaskMenuItem){
        self.timerController.stopTimer()
        Prefs.CurrentTaskID = sender.task.id
        self.loadTask()
        self.taskMenu.refreshChecks()
    }
    
    
    func fullRefresh(){
        self.taskMenu = TaskSubmenu()
        self.loadTask()
        self.constructMenu()
       
    }
    
    @objc func onWake(note: NSNotification) {
       self.fullRefresh()
    }
    
   
    
    func setFileNotifications() {
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(self.onWake(note:)),
            name: NSWorkspace.didWakeNotification, object: nil)
    }

}

