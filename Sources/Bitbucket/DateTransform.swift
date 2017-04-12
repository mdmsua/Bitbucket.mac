//
//  DateTransform.swift
//  Bitbucket
//
//  Created by Dmytro Morozov on 12.04.17.
//  Copyright © 2017 Dmytro Morozov. All rights reserved.
//

import Foundation
import ObjectMapper

class DateTransform: TransformType {
    typealias Object = Date
    typealias JSON = Int
    func transformFromJSON(_ value: Any?) -> Object? {
        if let value = value as? Int {
            if value > 0 {
                return Date(timeIntervalSince1970: Double(value / 1000))
            }
        }
        return nil
    }
    func transformToJSON(_ value: Object?) -> JSON? {
        if let date = value {
            return Int(Double(date.timeIntervalSince1970)) * 1000
        }
        return nil
    }
}
