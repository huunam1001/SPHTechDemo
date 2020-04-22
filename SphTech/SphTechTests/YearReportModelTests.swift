//
//  YearReportModelTests.swift
//  SphTechTests
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import XCTest
@testable import SphTech

class YearReportModelTests: XCTestCase {

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
    
    func testAddAreportToYear()
    {
        let report = ReportModel()
        report.reportId = 1
        report.year = 2008
        report.quarter = 1
        report.value = 0.23
        
        let yearRecord = YearReportModel()
        yearRecord.addReport(report)
        
        XCTAssertEqual(yearRecord.year, 2008)
        XCTAssertEqual(yearRecord.quartes.count, 1)
        XCTAssertEqual(yearRecord.totalValue, 0.23)
        XCTAssertFalse(yearRecord.hasQuarterDecrease)
    }
    
    func testAddListQuarter()
    {
        let year = 2008
        
        let yearRecord = YearReportModel()
        
        var total:Double = 0.0
        
        for i in 0 ... 3
        {
            let report = ReportModel()
            report.reportId = i + 1
            report.year = year
            report.quarter = i + 1
            report.value = Double.random(in: 1...100)
            
            total += report.value
            
            yearRecord.addReport(report)
        }
        
        XCTAssertEqual(yearRecord.year, 2008)
        XCTAssertEqual(yearRecord.quartes.count, 4)
        XCTAssertEqual(yearRecord.totalValue, total)
    }
    
    func testHasQuarterDecrease()
    {
        let year = 2008
        
        let yearRecord = YearReportModel()
                
        for i in 0 ... 3
        {
            let report = ReportModel()
            report.reportId = i + 1
            report.year = year
            report.quarter = i + 1
            
            if(i == 2)
            {
                report.value = 0.0
            }
            else
            {
                report.value = Double.random(in: 1...100)
            }
            
            yearRecord.addReport(report)
        }
        
        XCTAssertTrue(yearRecord.hasQuarterDecrease)
    }
    
    func testHasNoQuarterDecrease()
    {
        let year = 2008
        
        let yearRecord = YearReportModel()
                
        for i in 0 ... 3
        {
            let report = ReportModel()
            report.reportId = i + 1
            report.year = year
            report.quarter = i + 1
            report.value = Double(i)*10.0
            
            yearRecord.addReport(report)
        }
        
        XCTAssertFalse(yearRecord.hasQuarterDecrease)
    }
    
    func testAddOverFourRecords()
    {
        let year = 2008
        
        let yearRecord = YearReportModel()
        
        var quarter = 1
        
        for i in 0 ... 10
        {
            let report = ReportModel()
            report.reportId = i + 1
            report.year = year
            report.quarter = quarter
            report.value = Double(i)*10.0
            
            yearRecord.addReport(report)
            
            if(quarter == 4)
            {
                quarter = 1
            }
            else
            {
                quarter += 1
            }
        }
        
        XCTAssertEqual(yearRecord.quartes.count, 4)
    }
    
    func testAddQuaterGreaterThanFour()
    {
        let report = ReportModel()
        report.reportId = 1
        report.year = 2008
        report.quarter = 5
        report.value = 0.23
        
        let yearRecord = YearReportModel()
        yearRecord.addReport(report)
        
        XCTAssertEqual(yearRecord.year, 0)
        XCTAssertEqual(yearRecord.quartes.count, 0)
        XCTAssertEqual(yearRecord.totalValue, 0)
    }
    
    func testAddQuaterLessOrEqualZero()
    {
        let report = ReportModel()
        report.reportId = 1
        report.year = 2008
        report.quarter = 0
        report.value = 0.23
        
        let yearRecord = YearReportModel()
        yearRecord.addReport(report)
        
        XCTAssertEqual(yearRecord.year, 0)
        XCTAssertEqual(yearRecord.quartes.count, 0)
        XCTAssertEqual(yearRecord.totalValue, 0)
    }
    
    func testAddSameQuater()
    {
        let year = 2008
        let quarter = 1
        
        let yearRecord = YearReportModel()
                
        for i in 0 ... 20
        {
            let report = ReportModel()
            report.reportId = i + 1
            report.year = year
            report.quarter = quarter
            report.value = Double(i)*10.0
            
            yearRecord.addReport(report)
        }
        
        XCTAssertEqual(yearRecord.quartes.count, 1)
    }

}
