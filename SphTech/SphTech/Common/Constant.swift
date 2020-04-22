//
//  Constant.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import Foundation
import UIKit

// MARK:- Shorten constants

let CONTENT_MANAGER                 =   ContentManager.shareManager

// MARK:- Size constants

let SCREEN_WIDTH                    =   UIScreen.main.bounds.size.width
let SCREEN_HEIGHT                   =   UIScreen.main.bounds.size.height
let STATUS_HEIGHT                   =   UIApplication.shared.statusBarFrame.size.height
let NAVIGATION_HEIGHT               =   44 as CGFloat
let MARGIN_SIZE                     =   5 as CGFloat
let IPHONE_5_HEIGHT                 =   568 as CGFloat
let BOTTOM_DEVICE_MARGIN            =   STATUS_HEIGHT > 20 ? 34 : 0 as CGFloat

// MARK:- DB name

let DB_NAME                         =   "MobileNetwork.sqlite"

// MARK:- API URL

let API_REPORT                      =   "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=100"

// MARK:- API Method

let HTTP_GET                        =   "GET"
let HTTP_POST                       =   "POST"

// MARK:- Json Keys

let KEY_RESULT                      =   "result"
let KEY_RECORDS                     =   "records"
let KEY_ID                          =   "_id"
let KEY_QUARTER                     =   "quarter"
let KEY_VOLUME                      =   "volume_of_mobile_data"



