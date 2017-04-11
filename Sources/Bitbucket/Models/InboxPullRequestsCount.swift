//
//  InboxPullRequestsCount.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 11.04.17.
//  Copyright © 2017 Dmytro Morozov. All rights reserved.
//

import ObjectMapper

class InboxPullRequestsCount: Mappable {
    required init?(map: Map) { }
    private(set) var count: Int = 0
    func mapping(map: Map) {
        count <- map["count"]
    }
}
