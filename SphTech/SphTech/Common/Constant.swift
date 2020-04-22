//
//  Constant.swift
//  Acom
//
//  Created by Ninh Huu Nam on 2/18/20.
//  Copyright © 2020 Ninh Huu Nam. All rights reserved.
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



