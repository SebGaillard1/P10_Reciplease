//
//  ExtensionsTestCase.swift
//  P10_RecipleaseTests
//
//  Created by Sebastien Gaillard on 22/02/2022.
//

import Foundation
import XCTest

class ExtensionsTestCase: XCTestCase {
    func testGivenAStringWithMultipleWhitespaceWhenRemovingWhitespaceThenShouldHaveUniqueWhitespace() {
        let initalWord = "  test     word  "
        XCTAssertEqual(initalWord.condenseWhitespace(), "test word")
    }
    
    func testGivenAStringWhithInvalidCharactersWhenRemovingForbiddenCharactersThenShouldBeAStringWithOnlyLettersSpaceAndComma() {
        let initialWord = "chicken^$'-), fi!sh"
        XCTAssertEqual(initialWord.onlyLetters(), "chicken, fish")
    }
    
    func testGivenAn0MinutesWhenGettingStringThenShouldBeEmpty() {
        let time: Int16 = 0
        XCTAssertEqual(time.getStringFormattedTime(), "")
    }
    
    func testGivenAn30MinutesWhenGettingStringThenShouldReturnFormattedTimeInMinutes() {
        let time: Int16 = 30
        XCTAssertEqual(time.getStringFormattedTime(), "⏱30m")
    }
    
    func testGivenAn60MinutesWhenGettingStringThenShouldReturnFormattedTimeInHours() {
        let time: Int16 = 60
        XCTAssertEqual(time.getStringFormattedTime(), "⏱1h")
    }
    
    func testGivenAn65MinutesWhenGettingStringThenShouldReturnFormattedTimeInHoursWithMinutes() {
        let time: Int16 = 65
        XCTAssertEqual(time.getStringFormattedTime(), "⏱1h 5m")
    }
    
    func testGivenAn2000MinutesWhenGettingStringThenShouldReturnFormattedTimeInMinutes() {
        let time: Int16 = 2000
        XCTAssertEqual(time.getStringFormattedTime(), "⏱2000m")
    }
}
