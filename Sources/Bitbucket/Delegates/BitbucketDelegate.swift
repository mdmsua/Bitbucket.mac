//
//  BitbucketClient.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 29/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import KeychainAccess

class BitbucketClient: BitbucketProtocol {
    fileprivate let configuration: BitbucketConfiguration
    fileprivate var restApi: String {
        return "\(configuration.server)/rest/api/1.0"
    }
    fileprivate lazy var headers: HTTPHeaders = {
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: self.configuration.username,
                                                                 password: self.configuration.password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        return headers
    }()
    convenience init?() {
        if let configuration = BitbucketConfiguration() {
            self.init(with: configuration)
        } else {
            return nil
        }
    }
    init(with configuration: BitbucketConfiguration) {
        self.configuration = configuration
    }
    func getInboxPullRequestsCount(_ handler: @escaping (_ count: Int?, _ error: Error?) -> Void) {
        Alamofire.request("\(restApi)/inbox/pull-requests/count", headers: headers)
            .responseObject { (response: DataResponse<InboxPullRequestsCount>) in
                if let inboxPullRequestsCount = response.result.value {
                    handler(inboxPullRequestsCount.count, nil)
                }
        }
    }
    func getDashboardPullRequests(_ handler: @escaping (_ page: Page<DashboardPullRequest>?, _ error: Error?) -> Void) {
        Alamofire.request("\(restApi)/dashboard/pull-requests", headers: headers)
            .responseObject { (response: DataResponse<Page<DashboardPullRequest>>) in
                if let dashboardPullRequestPage = response.result.value {
                    handler(dashboardPullRequestPage, nil)
                }
        }
    }
}
