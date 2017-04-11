//
//  AppDelegate.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 28/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Cocoa
import Sentry

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet fileprivate weak var popover: NSPopover!

    private let dsn = "https://cb5739c5ac9d453284719beb8fe269f7:6cbe5139431e4e8b99bb2e5ed4e7b226@sentry.io/94601"

    fileprivate let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    fileprivate var timer: Timer?
    fileprivate static let fill = NSImage(named: "Fill")
    fileprivate static let zero = NSImage(named: "Zero")
    fileprivate static let sign = NSImage(named: "Sign")
    fileprivate static let load = NSImage(named: "Load")
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        enableSentry()
        statusItem.button?.image = AppDelegate.zero
        statusItem.button?.image?.isTemplate = true
        statusItem.button?.imagePosition = .imageLeft
        statusItem.button?.action = #selector(togglePopover)
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: "count"),
            object: nil,
            queue: nil) { [weak self] notification -> Void in
            if let count = notification.object as? Int {
                self?.updateStatusIcon(count)
            }
        }
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(rawValue: "interval"),
            object: nil,
            queue: nil) { [weak self] notification -> Void in
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
    @objc fileprivate func togglePopover() {
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }
    fileprivate func showPopover() {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
    internal func closePopover() {
        popover.performClose(self)
    }
    fileprivate func scheduleInboxCheck(_ interval: Double) {
        timer = Timer.scheduledTimer(
            timeInterval: 60.0 * interval,
            target: self,
            selector: #selector(checkInbox),
            userInfo: nil,
            repeats: true)
    }
    @objc fileprivate func checkInbox() {
        statusItem.button?.image = AppDelegate.load
        statusItem.button?.imagePosition = .imageOnly
        BitbucketClient()?.getInboxPullRequestsCount { [weak self] (count, error) in
            if let count = count {
                self?.updateStatusIcon(count)
            } else if error != nil {
                self?.updateStatusIcon(nil)
            }
        }
    }
    fileprivate func updateStatusIcon(_ count: Int?) {
        if let count = count {
            if count > 0 {
                self.statusItem.button?.image = AppDelegate.fill
                statusItem.button?.imagePosition = .imageLeft
                self.statusItem.button?.title = String(count)
            } else {
                self.statusItem.button?.image = AppDelegate.zero
            }
        } else {
            self.statusItem.button?.image = AppDelegate.sign
        }
    }
    fileprivate func enableSentry() {
        #if RELEASE
            SentryClient.shared = SentryClient(dsnString: dsn)
            SentryClient.shared?.startCrashHandler()
        #endif
    }
}
