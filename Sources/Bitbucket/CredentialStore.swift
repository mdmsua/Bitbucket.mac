//
//  CredentialStore.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 29/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation
import KeychainAccess

class CredentialStore {
    
    private static let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.defaultStore()
    
    static var server: String? {
        get {
            return ubiquitousKeyValueStore.stringForKey("server")
        }
        set {
            ubiquitousKeyValueStore.setString(newValue, forKey: "server")
        }
    }
    
    static var username: String? {
        get {
            return ubiquitousKeyValueStore.stringForKey("username")
        }
        set {
            ubiquitousKeyValueStore.setString(newValue, forKey: "username")
        }
    }
    
    static var password: String? {
        get {
            if let server = server, let username = username {
                let keychain = Keychain(server: server, protocolType: .HTTPS, authenticationType: .HTMLForm)
                do {
                    if let password = try keychain.get(username) {
                        return password
                    }
                } catch {
                    return nil
                }
            }
            return nil
        }
        set {
            if let server = server, let username = username, let value = newValue {
                let keychain = Keychain(server: server, protocolType: .HTTPS, authenticationType: .HTMLForm)
                do {
                    try keychain.set(value, key: username)
                } catch {
                    
                }
            }
        }
    }
}