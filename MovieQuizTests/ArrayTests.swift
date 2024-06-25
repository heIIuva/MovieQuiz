//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by big stepper on 6/20/24.
//

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        // given
        let array: [Int] = [1, 1, 2, 3, 5]
        // when
        let value = array[safe: 2]
        // then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {
        // given
        let array: [Int] = [1, 1, 2, 3, 5]
        // when
        let value = array[safe: 20]
        // then
        XCTAssertNil(value)
    }
    
    
}



