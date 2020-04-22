//
//  YearReportViewController.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import Foundation
import UIKit

class YearReportViewController: UIViewController {
    
    @IBOutlet weak var tblData:UITableView!
    
    var yearReportList = [YearReportModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    // MARK:- Methods
    
    private func setUpView()
    {
        self.title = "Year Report"
        
        tblData.contentInsetAdjustmentBehavior = .never
        tblData.width = SCREEN_WIDTH;
        tblData.top = NAVIGATION_HEIGHT + STATUS_HEIGHT
        tblData.height = SCREEN_HEIGHT - BOTTOM_DEVICE_MARGIN - tblData.top
        
        self.getReportFromSerever()
    }
    
    private func getReportFromSerever()
    {
        CONTENT_MANAGER.getTotalReport { (success, reports, errroMessage) in
            
            if(success)
            {
                self.filterReport(reports!)
            }
            else
            {
                print("user local database")
            }
        }
    }
    
    func filterReport(_ baseReport:[ReportModel])
    {
        let sortedList = baseReport.sorted { $0.reportId < $1.reportId}
        
        for reportRecord in sortedList
        {
            if(reportRecord.year >= 2008 && reportRecord.year <= 2018)
            {
                var foundYear: YearReportModel?  = nil
                
                for year in yearReportList
                {
                    if(reportRecord.year == year.year)
                    {
                        foundYear = year
                        
                        break
                    }
                }
                
                if(foundYear == nil)
                {
                    foundYear = YearReportModel()
                    foundYear!.addReport(reportRecord)
                    yearReportList.append(foundYear!)
                }
                else
                {
                    foundYear!.addReport(reportRecord)
                }
            }
        }
        
        tblData.reloadData()
    }
}
