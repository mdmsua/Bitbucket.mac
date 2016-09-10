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
    
    private var timer: NSTimer?
    
    private let fill = NSImage(named: "Fill")
    
    private let zero = NSImage(named: "Zero")
    
    private let sign = NSImage(named: "Sign")
    
    private let load = NSImage(named: "Load")
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem.button?.image = zero
        statusItem.button?.image?.template = true
        statusItem.button?.imagePosition = .ImageLeft
        statusItem.button?.action = #selector(togglePopover)
        NSNotificationCenter.defaultCenter().addObserverForName("count", object: nil, queue: nil) {
            [weak self] notification -> Void in
            if let count = notification.object as? Int {
                self?.updateStatusIcon(count)
            }
        }
        NSNotificationCenter.defaultCenter().addObserverForName("interval", object: nil, queue: nil) {
            [weak self] notification -> Void in
            if let interval = notification.object as? Double {
                self?.timer?.invalidate()
                self?.scheduleInboxCheck(interval)
            }
        }
        if SettingStore.interval > 0 {
            checkInbox()
            scheduleInboxCheck(SettingStore.interval)
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
    
    internal func closePopover() {
        popover.performClose(self)
    }
    
    private func scheduleInboxCheck(interval: Double) {
        timer = NSTimer.scheduledTimerWithTimeInterval(60.0 * interval, target: self, selector: #selector(checkInbox), userInfo: nil, repeats: true)
    }
    
    @objc private func checkInbox() {
        statusItem.button?.image = load
        statusItem.button?.imagePosition = .ImageOnly
        BitbucketClient()?.getInboxPullRequestsCount {
            [weak self] (count, error) in
            if let count = count {
                self?.updateStatusIcon(count)
            } else if let _ = error {
                self?.updateStatusIcon(nil)
            }
        }
    }
    
    private func updateStatusIcon(count: Int?) {
        if let count = count {
            if count > 0 {
                self.statusItem.button?.image = fill
                statusItem.button?.imagePosition = .ImageLeft
                self.statusItem.button?.title = String(count)
            } else {
                self.statusItem.button?.image = zero
            }
        } else {
            self.statusItem.button?.image = sign
        }
    }
}

