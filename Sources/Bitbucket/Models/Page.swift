//
//  Page.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 12.04.17.
//  Copyright © 2017 Dmytro Morozov. All rights reserved.
//

import ObjectMapper

class Page<T: Mappable>: Mappable {
    private(set) var size: Int = 0
    private(set) var limit: Int = 0
    private(set) var isLastPage: Bool = false
    private(set) var values: [T] = [T]()
    private(set) var start: Int = 0
    private(set) var nextPageStart: Int = 0
    required init?(map: Map) { }
    func mapping(map: Map) {
        size <- map["size"]
        limit <- map["limit"]
        isLastPage <- map["isLastPage"]
        values <- map["values"]
        start <- map["start"]
        nextPageStart <- map["nextPageStart"]
    }
}
