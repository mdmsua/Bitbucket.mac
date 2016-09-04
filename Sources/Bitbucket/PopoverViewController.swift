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
    
    @IBOutlet private weak var serverTextField: NSTextField!
    @IBOutlet private weak var usernameTextField: NSTextField!
    @IBOutlet private weak var passwordSecureTextField: NSSecureTextField!
    @IBOutlet private weak var saveButton: NSButton!
    @IBOutlet private weak var slider: NSSlider!
    @IBOutlet private weak var intervalTextField: NSTextField!
    @IBOutlet private weak var check: NSButton!
    
    @IBAction func save(sender: AnyObject) {
        let server = serverTextField.stringValue
        let username = usernameTextField.stringValue
        let password = passwordSecureTextField.stringValue
        BitbucketClient(server: server, username: username, password: password).getInboxPullRequestsCount {
            [weak self] (count, error) in
            if let error = error {
                let alert = NSAlert()
                alert.alertStyle = .CriticalAlertStyle
                alert.messageText = error.localizedDescription
                alert.runModal()
            } else {
                self?.saveSettings()
                NSNotificationCenter.defaultCenter().postNotificationName("count", object: count)
            }
        }
    }
    
    @IBAction func sliderAction(sender: NSSlider) {
        intervalTextField.stringValue = "\(sender.integerValue) m"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
    }
    
    private func saveSettings() {
        CredentialStore.server = serverTextField.stringValue
        CredentialStore.username = usernameTextField.stringValue
        CredentialStore.password = passwordSecureTextField.stringValue
        let state = check.state == NSOnState ? true : false
        let enabled = SMLoginItemSetEnabled("com.mdmsua.BitbucketAgent", state)
        SettingStore.autostart = enabled
        SettingStore.interval = slider.doubleValue
        NSNotificationCenter.defaultCenter().postNotificationName("interval", object: slider.doubleValue)
    }
    
    private func loadSettings() {
        slider.doubleValue = SettingStore.interval
        serverTextField.stringValue = CredentialStore.server ?? ""
        usernameTextField.stringValue = CredentialStore.username ?? ""
        passwordSecureTextField.stringValue = CredentialStore.password ?? ""
        check.state = SettingStore.autostart ? NSOnState : NSOffState
    }
    
}