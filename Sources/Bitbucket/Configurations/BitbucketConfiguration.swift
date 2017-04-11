//
//  BitbucketConfiguration.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 11.04.17.
//  Copyright © 2017 Dmytro Morozov. All rights reserved.
//

import Foundation

class BitbucketConfiguration {
    fileprivate let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.default()
    let server: String
    let username: String
    let password: String
    init?() {
        guard
            let server = CredentialStore.server,
            let username = CredentialStore.username,
            let password = CredentialStore.password else {
            return nil
        }
        self.server = server
        self.username = username
        self.password = password
    }
    init(server: String, username: String, password: String) {
        self.server = server
        self.username = username
        self.password = password
    }
}
