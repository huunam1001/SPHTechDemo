//
//  YearReportViewController.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import UIKit

class YearReportViewController: UIViewController {
    
    @IBOutlet weak var tblData:UITableView!

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
                print("save data to db and show UI")
            }
            else
            {
                print("user local database")
            }
        }
    }
}
