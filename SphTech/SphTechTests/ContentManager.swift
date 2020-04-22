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
    
    func testBaseApiFail()
    {
        let e = expectation(description: "API finish process")
        
        let urlString = "https://zzzzzzzdata.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=100"
        
        CONTENT_MANAGER.sendBaseRequest(urlString: urlString, params: nil, method: HTTP_GET, isRaw: false, showHud: false) { (success, dict, errorMessage) in
            
            XCTAssertFalse(success)
            XCTAssertNil(dict)
            XCTAssertNotNil(errorMessage)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }
    
    func testGetTotalReportFromServer()
    {
        let e = expectation(description: "API finish process")
        
        CONTENT_MANAGER.getTotalReportFromServer { (success, reports, errorMessage) in
            
            if(success)
            {
                XCTAssertNotNil(reports)
                XCTAssertNil(errorMessage)
            }
            else
            {
                XCTAssertNil(reports)
                XCTAssertNotNil(errorMessage)
            }
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }
    
    func testDatabasePath()
    {
        _ = CONTENT_MANAGER.copyDatabase()
        
        XCTAssertGreaterThan(CONTENT_MANAGER.dbPath.count, 0)
    }
    
    func testExecuteSqlSuccess()
    {
        _ = CONTENT_MANAGER.copyDatabase()
        
        let deleteSql = "DELETE FROM DataDetail WHERE Id = 0"
        
        let e = expectation(description: "SQL finish process")
        
        CONTENT_MANAGER.executeSql(deleteSql) { (success, message) in
            
            XCTAssertTrue(success)
    
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }
    
    func testExecuteSqlFail()
    {
        _ = CONTENT_MANAGER.copyDatabase()
        
        let deleteSql = "DELETE FROM DataDetailAbc WHERE Id = 0"
        
        let e = expectation(description: "SQL finish process")
        
        CONTENT_MANAGER.executeSql(deleteSql) { (success, message) in
            
            XCTAssertFalse(success)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }
    
    func testSelectSqlSuccess()
    {
        _ = CONTENT_MANAGER.copyDatabase()
        
        let selectSql = "SELECT * FROM DataDetail"
        
        let e = expectation(description: "SQL finish process")
        
        CONTENT_MANAGER.selectDataWithSql(selectSql) { (success, queryStatement, message) in
            
            XCTAssertTrue(success)
            XCTAssertNotNil(queryStatement)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }
    
    func testSelectSqlFail()
    {
        _ = CONTENT_MANAGER.copyDatabase()
        
        let selectSql = "SELECT * FROM DataDetailAbc"
        
        let e = expectation(description: "SQL finish process")
        
        CONTENT_MANAGER.selectDataWithSql(selectSql) { (success, queryStatement, message) in
            
            XCTAssertFalse(success)
            XCTAssertNil(queryStatement)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }
    
    func testGetLocalData()
    {
        _ = CONTENT_MANAGER.copyDatabase()
        
        let e = expectation(description: "SQL finish process")
        
        CONTENT_MANAGER.getAllReportFromLocal { (success, reports, errorMesage) in
            
            if(success)
            {
                XCTAssertNotNil(reports)
                XCTAssertNil(errorMesage)
            }
            else
            {
                XCTAssertNil(reports)
                XCTAssertNotNil(errorMesage)
            }
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }
    
    func testBathSaveDataLocalSuccess()
    {
        var dataList = [ReportModel]()
        
        for i in 0...3
        {
            let report = ReportModel()
            report.reportId = i*1000 + i
            report.year = 2000
            report.quarter = i + 1
            report.value = 0
            
            dataList.append(report)
        }
        
        _ = CONTENT_MANAGER.copyDatabase()
        
        let e = expectation(description: "SQL finish process")
        
        CONTENT_MANAGER.batchSaveToLocal(dataList) { (success, errorMessage) in
            
            XCTAssertTrue(success)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }
    
    func testBathSaveDataLocalFail()
    {
        _ = CONTENT_MANAGER.copyDatabase()
        
        let e = expectation(description: "SQL finish process")
        
        CONTENT_MANAGER.batchSaveToLocal([ReportModel]()) { (success, errorMessage) in
            
            XCTAssertFalse(success)
            
            e.fulfill()
        }
        
        waitForExpectations(timeout: 30.0) { (error) in
            print("Timed out")
        }
    }

}
