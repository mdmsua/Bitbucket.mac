//
//  User.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 12.04.17.
//  Copyright © 2017 Dmytro Morozov. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    private(set) var name: String = ""
    private(set) var emailAddress: String = ""
    private(set) var id: Int = 0
    private(set) var displayName: String = ""
    private(set) var active: Bool = false
    private(set) var slug: String = ""
    private(set) var type: String = ""
    private(set) var link: String = ""
    var avatar: String {
        return "\(link)/avatar.png"
    }
    required init?(map: Map) { }
    init() { }
    func mapping(map: Map) {
        name <- map["name"]
        emailAddress <- map["emailAddress"]
        id <- map["id"]
        displayName <- map["displayName"]
        active <- map["active"]
        slug <- map["slug"]
        type <- map["type"]
        link <- map["links.self.0.href"]
    }
}
