//
//  BitbucketRequestAdapter.swift
//  PR
//
//  Created by Dmytro Morozov on 22.09.16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Alamofire

class BitbucketRequestAdapter: RequestAdapter {
    
    fileprivate let username: String
    
    fileprivate let password: String
    
    fileprivate var encoded: String {
        get {
            let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
            return credentialData.base64EncodedString(options: [])
        }
    }
    
    convenience init?() {
        if let username = CredentialStore.username, let password = CredentialStore.password {
            self.init(username: username, password: password)
        } else {
            return nil
        }
    }
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
    
}
