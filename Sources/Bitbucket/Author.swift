//
//  Author.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 12.04.17.
//  Copyright © 2017 Dmytro Morozov. All rights reserved.
//

import ObjectMapper

class Author: Mappable {
    private(set) var user: User = User()
    private(set) var role: Role = .author
    private(set) var approved: Bool = false
    private(set) var status: Status = .unapproved
    required init?(map: Map) { }
    init() { }
    func mapping(map: Map) {
        user <- map["user"]
        role <- map["role"]
        approved <- map["approved"]
        status <- map["status"]
    }
}
