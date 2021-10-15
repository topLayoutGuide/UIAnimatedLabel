//
//  UIAnimatedLabelTests.swift
//  UIAnimatedLabelTests
//
//  Created by Ben Deckys on 2021/10/15.
//

import XCTest
@testable import UIAnimatedLabel

class UIAnimatedLabelTests: XCTestCase {

    var label: UIAnimatedLabel!

    override func setUpWithError() throws {
        label = UIAnimatedLabel(frame: .init(x: 0, y: 0, width: 100, height: 50))
    }

    override func tearDownWithError() throws {
        label = nil
    }

    func test_noDecimals() throws {
        label.count(from: 0, to: 100, duration: 0) { [weak self] in
            XCTAssertTrue(self?.label.text == "100")
        }
    }

    func test_oneDecimal() throws {
        let expectedValue = "100.0"

        label.decimalPoints = .one
        label.count(from: 0, to: 100, duration: 0) { [weak self] in
            XCTAssertTrue(self?.label.text == expectedValue)
        }
    }

    func test_twoDecimals() throws {
        let expectedValue = "100.00"

        label.decimalPoints = .two
        label.count(from: 0, to: 100, duration: 0) { [weak self] in
            XCTAssertTrue(self?.label.text == expectedValue)
        }
    }

}
