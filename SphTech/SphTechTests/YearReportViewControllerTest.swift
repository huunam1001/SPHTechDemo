//
//  YearReportViewControllerTest.swift
//  SphTechTests
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import XCTest
@testable import SphTech

class YearReportViewControllerTest: XCTestCase {

    var controller: YearReportViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    override func setUp() {
        super.setUp()
        
        controller = YearReportViewController()
        
        var tempData = [YearReportModel]()
        
        let year = 2008
        for i in 0...4
        {
            let yearReport = YearReportModel()
            
            yearReport.year = year + i
            yearReport.totalValue = Double.random(in: 1...100)
            yearReport.hasQuarterDecrease = false
            
            tempData.append(yearReport)
        }
        
        controller.yearReportList = tempData
        
        controller.loadView()
        controller.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHasATableView() {
        
        XCTAssertNotNil(controller.tblData)
    }
    
    func testTableViewHasDelegate() {
        
        XCTAssertNotNil(controller.tblData.delegate)
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(controller.tblData.dataSource)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
        
        XCTAssertTrue(controller.conforms(to: UITableViewDelegate.self))
        
        XCTAssertTrue(controller.responds(to: #selector(controller.tableView(_:didSelectRowAt:))))
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        
        XCTAssertTrue(controller.conforms(to: UITableViewDataSource.self))
        
        XCTAssertTrue(controller.responds(to: #selector(controller.tableView(_:numberOfRowsInSection:))))
        
        XCTAssertTrue(controller.responds(to: #selector(controller.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewCellHasReuseIdentifier() {
        
        let cell = controller.tableView(controller.tblData, cellForRowAt: IndexPath(row: 0, section: 0)) as? YearReportTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        
        XCTAssertEqual(actualReuseIdentifer, "Cell")
    }
    
    func testTableCellHasCorrectLabelText() {
        
        let index = 1
        
        let cell1 = controller.tableView(controller.tblData, cellForRowAt: IndexPath(row: index, section: 0)) as? YearReportTableViewCell
        XCTAssertEqual(cell1?.lblYear.text, "2009")
    }

}
