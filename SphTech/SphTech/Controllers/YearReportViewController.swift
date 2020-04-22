//
//  YearReportViewController.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import Foundation
import UIKit

class YearReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        
        tblData.register(UINib(nibName: "YearReportTableViewCell", bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER)
        tblData.delegate = self
        tblData.dataSource = self
        
        self.getReportFromSerever()
    }
    
    private func getReportFromSerever()
    {
        CONTENT_MANAGER.getTotalReportFromServer { (success, reports, errroMessage) in
            
            if(success)
            {
                self.filterReport(reports!)
                
                self.saveDataToLocal(reports!)
            }
            else
            {
                self.useOfflineMode()
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
    
    private func saveDataToLocal(_ dataList:[ReportModel])
    {
        CONTENT_MANAGER.batchSaveToLocal(dataList) { (success, errorMessage) in
            
            if(!success)
            {
                let arlert = UIAlertController.init(title: "Error", message: "Error save data to local", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                arlert.addAction(okButton)
                
                self.present(arlert, animated: true, completion: nil)
            }
            else
            {
                print("Synced successfully")
            }
        }
    }
    
    private func useOfflineMode()
    {
        CONTENT_MANAGER.getAllReportFromLocal { (success, reports, errorMessage) in
            
            if(success)
            {
                self.filterReport(reports!)
            }
            else
            {
                let arlert = UIAlertController.init(title: "Error", message: "Error get local data.\nPlease try again later", preferredStyle: .alert)
                
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                arlert.addAction(okButton)
                
                self.present(arlert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK:- TableView's delegate & data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return yearReportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblData.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as! YearReportTableViewCell
        cell.width = tblData.width
        
        cell.setCellWithYearReport(yearReportList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(yearReportList[indexPath.row].hasQuarterDecrease)
        {
            print("You can show detail with this record")
        }
    }
}
