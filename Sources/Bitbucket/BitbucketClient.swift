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
    fileprivate let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.default()
    fileprivate var server: String
    fileprivate var username: String
    fileprivate var password: String
    init?() {
        if let server = CredentialStore.server,
        let username = CredentialStore.username,
        let password = CredentialStore.password {
            self.server = server
            self.username = username
            self.password = password
        } else {
            return nil
        }
    }
    init(server: String, username: String, password: String) {
        self.server = server
        self.username = username
        self.password = password
    }
    func getInboxPullRequestsCount(_ handler: @escaping (_ count: Int?, _ error: Error?) -> Void) {
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: username, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        Alamofire.request("\(server)/rest/api/1.0/inbox/pull-requests/count", headers: headers)
            .responseJSON { response in
                if let json = response.result.value as? [String: Any] {
                    if let count = json["count"] as? Int {
                        handler(count, nil)
                    } else if let errors = json["errors"] as? [AnyObject],
                    let error = errors[0] as? [String: AnyObject],
                    let message = error["message"] as? String {
                        let error = NSError(
                            domain: "bitbucket",
                            code: -(response.response?.statusCode)!,
                            userInfo: [NSLocalizedDescriptionKey: NSLocalizedString(message, comment: "")])
                        handler(nil, error)
                    }
                } else if let error = response.result.error {
                    handler(nil, error)
                }
        }
    }
}
