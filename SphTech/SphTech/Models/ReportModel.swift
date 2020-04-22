//
//  ReportModel.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import UIKit

class ReportModel: NSObject {
    
    var reportId: Int = 0
    var year:Int = 0
    var quater:Int = 0
    var value:Double = 0.0
    
    class func reportModelFromDictionary(_ dict: [String:Any]) -> ReportModel
    {
        let report = ReportModel()
        
        if let id = dict[KEY_ID] as? NSNumber
        {
            report.reportId = id.intValue
        }
        
        if let dateString = dict[KEY_QUARTER] as? String
        {
            let dateComponents = dateString.components(separatedBy: "-Q")
            
            if(dateComponents.count == 2)
            {
                report.year = Int(dateComponents[0]) ?? 0
                report.quater = Int(dateComponents[0]) ?? 0
            }
        }
        
        if let volume = dict[KEY_VOLUME] as? String
        {
            report.value = Double(volume) ?? 0
        }
        
        return report
    }
    
}
