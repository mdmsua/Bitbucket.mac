//
//  AppDelegate.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 28/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet private weak var popover: NSPopover!

    private let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.button?.image = NSImage(named: "Bitbucket")
        statusItem.button?.image?.template = true
        statusItem.button?.imagePosition = .ImageLeft
        statusItem.button?.action = #selector(togglePopover)
        NSNotificationCenter.defaultCenter().addObserverForName("count", object: nil, queue: nil) {
            [weak self] notification -> Void in
            if let count = notification.object as? Int {
                self?.statusItem.button?.title = String(count)
            }
        }
    }
    
    @objc private func togglePopover() {
        if (popover.shown) {
            closePopover()
        } else {
            showPopover()
        }
    }
    
    private func showPopover() {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: .MinY)
        }
    }
    
    private func closePopover() {
        popover.performClose(self)
    }
}

