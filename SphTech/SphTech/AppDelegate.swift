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
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let navi = UINavigationController(rootViewController: YearReportViewController())
        
        self.window?.rootViewController = navi
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
                
        if #available(iOS 13, *)
        {
            self.window?.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        }
        
        return true
    }
}

