//
//  CredentialStore.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 29/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation
import KeychainAccess
import Sentry

class CredentialStore {
    fileprivate static let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.default()
    static var server: String? {
        get {
            return ubiquitousKeyValueStore.string(forKey: "server")
        }
        set {
            ubiquitousKeyValueStore.set(newValue, forKey: "server")
        }
    }
    static var username: String? {
        get {
            return ubiquitousKeyValueStore.string(forKey: "username")
        }
        set {
            ubiquitousKeyValueStore.set(newValue, forKey: "username")
        }
    }
    static var password: String? {
        get {
            if let server = server, let username = username {
                let keychain = Keychain(server: server, protocolType: .https, authenticationType: .htmlForm)
                do {
                    if let password = try keychain.get(username) {
                        return password
                    }
                } catch let error as NSError {
                    SentryClient.shared?.captureError(error: error)
                    return nil
                }
            }
            return nil
        }
        set {
            if let server = server, let username = username, let value = newValue {
                let keychain = Keychain(server: server, protocolType: .https, authenticationType: .htmlForm)
                do {
                    try keychain.set(value, key: username)
                } catch let error as NSError {
                    SentryClient.shared?.captureError(error: error)
                }
            }
        }
    }
}
