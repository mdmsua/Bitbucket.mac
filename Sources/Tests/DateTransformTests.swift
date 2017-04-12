//
//  DateTransformTests.swift
//  DateTransformTests
//
//  Created by Dmytro Morozov on 28/08/2016.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import XCTest

class SampleTests: XCTestCase {
    private let transform = DateTransform()
    func testTransformFromJSONWithNil() {
        XCTAssertNil(transform.transformFromJSON(nil))
    }
    func testTransformFromJSONWithNonInt() {
        XCTAssertNil(transform.transformFromJSON(""))
    }
    func testTransformFromJSONWithNegativeInt() {
        XCTAssertNil(transform.transformFromJSON(-1))
    }
    func testTransformFromJSONWithZero() {
        XCTAssertNil(transform.transformFromJSON(0))
    }
    func testTransformFromJSONWithPositiveInt() {
        let components = DateComponents(year: 2017, month: 1, day: 1, hour: 11, minute: 22, second: 33)
        let expected =  Calendar.current.date(from: components)
        let input = Int((expected?.timeIntervalSince1970)! * 1000)
        let actual = transform.transformFromJSON(input)
        XCTAssertEqual(actual, expected)
    }
    func testTransformToJSONWithNil() {
        XCTAssertNil(transform.transformToJSON(nil))
    }
    func testTransformToJSONWithDate() {
        let components = DateComponents(year: 2017, month: 1, day: 1, hour: 11, minute: 22, second: 33)
        let date = Calendar.current.date(from: components)
        let expected = Int((date?.timeIntervalSince1970)! * 1000)
        let actual = transform.transformToJSON(date)
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual, expected)
    }
}
