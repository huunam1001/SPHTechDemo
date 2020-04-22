//
//  ReportModelTests.swift
//  SphTechTests
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import XCTest
@testable import SphTech

class ReportModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
//        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testModelParseRightJson()
    {
        let json:[String: Any] = ["volume_of_mobile_data": "3.336984", "quarter": "2010-Q4", "_id": 26]
        
        let report = ReportModel.reportModelFromDictionary(json)
        
        XCTAssertEqual(report.reportId, 26)
        XCTAssertEqual(report.year, 2010)
        XCTAssertEqual(report.quarter, 4)
        XCTAssertEqual(report.value, 3.336984)
    }
    
    func testModelParseWrongJsonFormat()
    {
        let json:[String: Any] = ["volume_of_mobile_data": "3.336984", "quarter": "2010-Q4"]
        
        let report = ReportModel.reportModelFromDictionary(json)
        
        XCTAssertEqual(report.reportId, 0)
        XCTAssertEqual(report.year, 2010)
        XCTAssertEqual(report.quarter, 4)
        XCTAssertEqual(report.value, 3.336984)
    }

}
