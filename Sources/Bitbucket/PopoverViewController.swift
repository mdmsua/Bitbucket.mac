//
//  PopoverViewController.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 28/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Cocoa
import KeychainAccess
import Alamofire

class PopoverViewController: NSViewController {
    
    @IBOutlet private weak var serverTextField: NSTextField!
    @IBOutlet private weak var usernameTextField: NSTextField!
    @IBOutlet private weak var passwordSecureTextField: NSSecureTextField!
    @IBOutlet private weak var saveButton: NSButton!
    
    private let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.defaultStore()
    
    @IBAction func save(sender: AnyObject) {
        let server = serverTextField.stringValue
        let username = usernameTextField.stringValue
        let password = passwordSecureTextField.stringValue
        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        Alamofire.request(.GET, "\(server)/rest/api/1.0/inbox/pull-requests/count", headers: headers)
            .responseJSON { [weak self] response in
                if let json = response.result.value {
                    if let count = json["count"] as? Int {
                        self?.setCredentials(server, username: username, password: password)
                        NSNotificationCenter.defaultCenter().postNotificationName("count", object: count)
                    }
                    else if let errors = json["errors"] as? [AnyObject], let error = errors[0] as? [String: AnyObject], let message = error["message"] as? String {
                        let alert = NSAlert()
                        alert.alertStyle = .CriticalAlertStyle
                        alert.messageText = message
                        alert.runModal()
                    }
                }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let server = ubiquitousKeyValueStore.stringForKey("server"), let username = ubiquitousKeyValueStore.stringForKey("username") {
                serverTextField.stringValue = server
                usernameTextField.stringValue = username
                getCredentials(server, username: username)
        }
    }
    
    private func getCredentials(server: String, username: String) {
        let keychain = Keychain(server: server, protocolType: .HTTPS, authenticationType: .HTMLForm)
        do {
            if let password = try keychain.get(username) {
                passwordSecureTextField.stringValue = password
            }
        } catch {
            
        }
    }
    
    private func setCredentials(server: String, username: String, password: String) {
        let keychain = Keychain(server: server, protocolType: .HTTPS, authenticationType: .HTMLForm)
        do {
            try keychain.set(password, key: username)
        } catch {
            
        }
        ubiquitousKeyValueStore.setString(server, forKey: "server")
        ubiquitousKeyValueStore.setString(username, forKey: "username")
    }
    
}