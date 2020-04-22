//
//  YearReportModel.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import UIKit

class YearReportModel: NSObject {
    
    var year:Int = 0
    var totalValue: Double = 0
    var hasQuarterDecrease: Bool = false
    var quartes = [ReportModel]()
    
    func addReport(_ report:ReportModel)
    {
        let findQuarterIndex = quartes.firstIndex(where: { $0.quarter == report.quarter }) ?? -1
        
        if(quartes.count < 4
            && findQuarterIndex == -1
            && report.quarter <= 4
            && report.quarter > 0)
        {
            self.year = report.year
            self.totalValue += report.value
            
            if(quartes.count > 0 && !hasQuarterDecrease)
            {
                if(quartes[quartes.count - 1].value > report.value)
                {
                    hasQuarterDecrease = true
                }
            }
            
            self.quartes.append(report)
        }
    }
}
