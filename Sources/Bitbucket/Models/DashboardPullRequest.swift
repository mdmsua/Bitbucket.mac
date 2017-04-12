//
//  DashboardPullRequest.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 12.04.17.
//  Copyright © 2017 Dmytro Morozov. All rights reserved.
//

import ObjectMapper

class DashboardPullRequest: Mappable {
    private(set) var id: Int = 0
    private(set) var version: Int = 0
    private(set) var title: String = ""
    private(set) var description: String = ""
    private(set) var open: Bool = false
    private(set) var closed: Bool = false
    private(set) var createdDate: Date = Date()
    private(set) var updatedDate: Date = Date()
    required init?(map: Map) { }
    func mapping(map: Map) {
        id <- map["id"]
        version <- map["version"]
        title <- map["title"]
        description <- map["description"]
        open <- map["open"]
        closed <- map["closed"]
        createdDate <- (map["createdDate"], DateTransform())
        createdDate <- (map["createdDate"], DateTransform())
    }
}
