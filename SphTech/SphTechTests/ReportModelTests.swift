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
