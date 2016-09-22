//
//  SettingStore.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 29/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

class SettingStore {
    
    fileprivate static let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.default()
    
    static var interval: Double {
        get {
            return ubiquitousKeyValueStore.double(forKey: "interval")
        }
        set {
            ubiquitousKeyValueStore.set(newValue, forKey: "interval")
        }
    }
    
    static var autostart: Bool {
        get {
            return ubiquitousKeyValueStore.bool(forKey: "autostart")
        }
        set {
            ubiquitousKeyValueStore.set(newValue, forKey: "autostart")
        }
    }
    
}
