//
//  AppDelegate.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let url = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=100"
//
//        ContentManager.shareManager.sendBaseRequest_(urlString: url, params: nil, method: "GET", isRaw: true, showHud: true) { (success, dict, errorMessage) in
//
//        }
        
        CONTENT_MANAGER.copyDatabaseIfNeeded()
        
        let sql = "Select * From DataDetail"
        
        CONTENT_MANAGER.selectDataWithSql(sql) { (success, qeryStatement, message) in
            
            print("Finish")
        }
        
        return true
    }
}

