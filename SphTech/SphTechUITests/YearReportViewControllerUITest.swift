//
//  YearReportViewControllerUITest.swift
//  SphTechUITests
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import XCTest
import UIKit

class YearReportViewControllerUITest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
        
    func testOutlet()
    {
        let app = XCUIApplication()
        
        let aboutTitleText = app.navigationBars.otherElements["Year Report"]
        
        XCTAssertTrue(aboutTitleText.exists)
        
        XCTAssertNotNil(app.tables["tblData"])
    }
    
    func testOnlyTable()
    {
        let app = XCUIApplication()
        
        XCTAssertEqual(app.tables.count, 1)
    }
    
    func testSrcollTable()
    {
        let app = XCUIApplication()
        
        let topCoordinate = app.statusBars.firstMatch.coordinate(withNormalizedOffset: .zero)
        let myElement = app.staticTexts["2017"].coordinate(withNormalizedOffset: .zero)
        // drag from element to top of screen (status bar)
        myElement.press(forDuration: 0.1, thenDragTo: topCoordinate)
    }
    
    func testTapOnCells()
    {
        let app = XCUIApplication()
        
        for i in 0...10
        {
            app.staticTexts["\(2008 + i)"].tap()
        }
    }

    
}
