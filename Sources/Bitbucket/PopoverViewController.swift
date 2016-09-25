//
//  PopoverViewController.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 28/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Cocoa
import ServiceManagement

class PopoverViewController: NSViewController {
    
    @IBOutlet fileprivate weak var serverTextField: NSTextField!
    @IBOutlet fileprivate weak var usernameTextField: NSTextField!
    @IBOutlet fileprivate weak var passwordSecureTextField: NSSecureTextField!
    @IBOutlet fileprivate weak var saveButton: NSButton!
    @IBOutlet fileprivate weak var slider: NSSlider!
    @IBOutlet fileprivate weak var intervalTextField: NSTextField!
    @IBOutlet fileprivate weak var check: NSButton!
    @IBOutlet fileprivate weak var version: NSTextField!
    @IBOutlet fileprivate weak var copyright: NSTextField!
    @IBOutlet fileprivate weak var reference: NSTextField!
    @IBOutlet fileprivate weak var progressIndicator: NSProgressIndicator!
    
    var appDelegate: AppDelegate {
        get {
            return NSApplication.shared().delegate as! AppDelegate
        }
    }
    
    @IBAction func onTextFieldPressEnter(_ sender: AnyObject) {
        self.save(sender);
    }
    
    @IBAction func save(_ sender: AnyObject) {
        let server = serverTextField.stringValue
        let username = usernameTextField.stringValue
        let password = passwordSecureTextField.stringValue
        saveButton.isHidden = true
        progressIndicator.startAnimation(sender)
        BitbucketClient(server: server, username: username, password: password).getInboxPullRequestsCount {
            [weak self] (count, error) in
            self?.progressIndicator.stopAnimation(sender)
            self?.saveButton.isHidden = false
            if let error = error {
                self?.showErrorMessage(error)
            } else {
                self?.saveSettings()
                self?.appDelegate.closePopover()
            }
        }
    }
    
    @IBAction fileprivate func sliderAction(_ sender: NSSlider) {
        intervalTextField.stringValue = "\(sender.integerValue) m"
    }
    
    @IBAction fileprivate func quit(_ sender: AnyObject) {
        NSApp.terminate(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        loadAbout()
    }
    
    fileprivate func saveSettings() {
        CredentialStore.server = serverTextField.stringValue
        CredentialStore.username = usernameTextField.stringValue
        CredentialStore.password = passwordSecureTextField.stringValue
        let state = check.state == NSOnState ? true : false
        let enabled = SMLoginItemSetEnabled("mac.toolbox.pr.agent" as CFString, state)
        SettingStore.autostart = enabled
        SettingStore.interval = slider.doubleValue
        NotificationCenter.default.post(name: Notification.Name(rawValue: "interval"), object: slider.doubleValue)
    }
    
    fileprivate func loadSettings() {
        slider.doubleValue = SettingStore.interval
        serverTextField.stringValue = CredentialStore.server ?? ""
        usernameTextField.stringValue = CredentialStore.username ?? ""
        passwordSecureTextField.stringValue = CredentialStore.password ?? ""
        check.state = SettingStore.autostart ? NSOnState : NSOffState
        sliderAction(slider)
    }
    
    fileprivate func loadAbout() {
        if let bundleShortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, let bundleVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") {
            version.stringValue = "\(bundleShortVersion) (\(bundleVersion))"
        }
        if let bundleReadableCopyright = Bundle.main.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String {
            copyright.stringValue = bundleReadableCopyright
        }
    }
    
    fileprivate func showErrorMessage(_ error: Error) {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = error.localizedDescription
        alert.runModal()
    }
    
    @IBAction fileprivate func openLink(_ sender: NSButton) {
        NSWorkspace.shared().open(URL(string: "https://icons8.com")!)
    }
}
