//
//  SettingStore.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 29/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Foundation

class SettingStore {
    
    private static let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.defaultStore()
    
    static var interval: Double {
        get {
            return ubiquitousKeyValueStore.doubleForKey("interval")
        }
        set {
            ubiquitousKeyValueStore.setDouble(newValue, forKey: "interval")
        }
    }
    
}