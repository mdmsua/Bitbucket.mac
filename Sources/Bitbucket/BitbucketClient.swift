//
//  BitbucketClient.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 29/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Alamofire
import KeychainAccess

class BitbucketClient {
    
    private let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.defaultStore()
    
    private var server: String
    
    private var username: String
    
    private var password: String
    
    init?() {
        if let server = CredentialStore.server, let username = CredentialStore.username, let password = CredentialStore.password {
            self.server = server
            self.username = username
            self.password = password
        }
        else {
            return nil
        }
    }
    
    init(server: String, username: String, password: String) {
        self.server = server
        self.username = username
        self.password = password
    }
    
    func getInboxPullRequestsCount(handler: (count: Int?, error: NSError?) -> Void) {
        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        Alamofire.request(.GET, "\(server)/rest/api/1.0/inbox/pull-requests/count", headers: headers)
            .responseJSON { response in
                if let json = response.result.value {
                    if let count = json["count"] as? Int {
                        handler(count: count, error: nil)
                    }
                    else if let errors = json["errors"] as? [AnyObject], let error = errors[0] as? [String: AnyObject], let message = error["message"] as? String {
                        let error = NSError(domain: "bitbucket", code: -(response.response?.statusCode)!, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(message, comment: "")])
                        handler(count: nil, error: error)
                    }
                } else if let error = response.result.error {
                    handler(count: nil, error: error)
                }
        }
    }
    
}