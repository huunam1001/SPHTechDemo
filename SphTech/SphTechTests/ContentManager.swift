//
//  ContentManager.swift
//  SphTechTests
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import XCTest
@testable import SphTech

class ContentManager: XCTestCase {

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
    
    func testBaseApiSuccess()
    {
        let e = expectation(description: "API finish process")
        
        let urlString = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=100"
        
        CONTENT_MANAGER.sendBaseRequest(urlString: urlString, params: nil, method: HTTP_GET, isRaw: false, showHud: false) { (success, dict, errorMessage) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(dict)
            XCTAssertNil(errorMessage)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }

}
