//
//  YearReportTableViewCell.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import UIKit

class YearReportTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblYear:UILabel!
    @IBOutlet weak var lblValue:UILabel!
    @IBOutlet weak var imgStatus:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.selectionStyle = .none
        
        lblValue.font = UIFont.boldSystemFont(ofSize: 18)
        lblValue.textAlignment = .right
        
        imgStatus.image = UIImage(named: "down")
    }
    
    func setCellWithYearReport(_ yearReport:YearReportModel)
    {
        lblYear.top = 0
        lblYear.left = MARGIN*4
        lblYear.height = self.height
        
        imgStatus.right = self.width - MARGIN*4
        imgStatus.top = (self.height - imgStatus.height)/2
        
        lblValue.top = 0
        lblValue.height = self.height
        lblValue.right = imgStatus.left - MARGIN
        
        lblYear.text = "\(yearReport.year)"
        lblValue.text = String(format: "%.2f", yearReport.totalValue)
        
        if(yearReport.hasQuarterDecrease)
        {
            lblYear.textColor = UIColor.red
            lblValue.textColor = UIColor.red
            
            imgStatus.isHidden = false
            
            self.selectionStyle = .gray
        }
        else
        {
            lblYear.textColor = UIColor.black
            lblValue.textColor = UIColor.black
            
            imgStatus.isHidden = true
            
            self.selectionStyle = .none
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
