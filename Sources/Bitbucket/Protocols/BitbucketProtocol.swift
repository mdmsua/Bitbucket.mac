//
//  BitbucketProtocol.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 11.04.17.
//  Copyright © 2017 Dmytro Morozov. All rights reserved.
//

protocol BitbucketProtocol {
    func getInboxPullRequestsCount(_ handler: @escaping (_ count: Int?, _ error: Error?) -> Void)
}
