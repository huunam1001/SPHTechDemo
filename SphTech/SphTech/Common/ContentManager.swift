//
//  ContentManager.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import UIKit
import SystemConfiguration
import SQLite3

class ContentManager: NSObject {
    
    // MARK:- Internal variables
    
    var db:OpaquePointer? = nil
    var dbPath:String = ""
    
    fileprivate var numberOfDeviceLoading  = 0
    fileprivate var numberOfHudLoading  = 0

    // MARK:- Singleton
    
    static let shareManager = ContentManager()
    
    // MARK:- API Calling
    
    func getTotalReport(callBack:@escaping (_ success:Bool,_ reports:[ReportModel]?,_ message:String?)->Void)
    {
        self.sendBaseRequest(urlString: API_REPORT, params: nil, method: HTTP_GET, isRaw: false, showHud: true) { (success, dict, errorMessage) in
            
            if(success)
            {
                var reportList: [ReportModel]? = nil
                var success:Bool = false
                var message:String? = "Server return wrong data"
                
                if let resultDict = dict![KEY_RESULT] as? [String: Any]
                {
                    if let recordDict = resultDict[KEY_RECORDS] as? [[String: Any]]
                    {
                        success = true
                        message = nil
                        reportList = [ReportModel]()
                        
                        for tempDict in recordDict
                        {
                            reportList?.append(ReportModel.reportModelFromDictionary(tempDict))
                        }
                    }
                }
                
                callBack(success, reportList, message)
            }
            else
            {
                callBack(false, nil, errorMessage)
            }
        }
    }
    
    // MARK:- Base API request
    
    /// Call all API
    /// - Parameters:
    ///   - urlString: Input url of API
    ///   - params: Params of API
    ///   - method: Http Method of API
    ///   - isRaw: Just affect with http method is differ GET. And this value depends on API input param defination
    ///   - showHud: Show loading when API calling
    ///   - completion: Data callback
    func sendBaseRequest(urlString: String,params:[String:Any]?,method:String,isRaw:Bool,showHud:Bool,completion:@escaping (_ success:Bool,_ response:[String:Any]?,_ message:String?)->Void)
    {
        if(!self.isConnectedToNetwork())
        {
            completion(false, nil, "No internet connection")
            
            return
        }
        
        /**
         * Show network loading
         */
        self.setNetworkActivityIndicatorVisible(true)
        
        /**
         * Check if showHud flag was set, show hud loading
         */
        if(showHud)
        {
            self.setHudLoaderVisible(true)
        }

        let request = self.createRequest(urlString, params: params, method: method, isRaw: isRaw)
        
        let task = URLSession.shared.dataTask(with: request!) { (data, res, error) in
            
            var success: Bool
            var message: String?
            var json: [String:Any]?
            
            if error != nil {
                success = false
                message = error?.localizedDescription
                json = nil
            }
            else {
                let httpRes = res as! HTTPURLResponse
                
                print(httpRes.statusCode)
                
                if(httpRes.statusCode == 200 ) {
                    do {
                        json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                        success = true;
                        message = nil;
                        
                        print("json: \(json!)")
                    }
                    catch {
                        success = false;
                        message = "Error parse data";
                    }
                }
                else {
                    success = false
                    message = "Error on SERVER"
                    json = nil
                }
            }
            
            /**
            * Change app to main thread
            */
            DispatchQueue.main.async {
                
                /**
                 * Hide network loading
                 */
                self.setNetworkActivityIndicatorVisible(false)
                
                /**
                 * Check if showHud flag was set, hide hud loading
                 */
                if(showHud)
                {
                    self.setHudLoaderVisible(false)
                }
                
                /**
                 * Send datas to implementer
                 */
                completion(success, json, message)
            }
        }
        
        task.resume()
    }
    
    /// Build request before API calling
    /// - Parameters:
    ///   - urlString: Input API url
    ///   - params: Json param of API
    ///   - method: Http Method of API
    ///   - isRaw: Just affect with http method is differ GET. And this value depends on API input param defination
    /// - Returns: An url request
    private func createRequest(_ urlString:String,params:[String:Any]?,method:String,isRaw:Bool) -> URLRequest!
    {
        let url                     = URL(string:urlString)
        var request                 = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 60
        request.httpMethod = method
        
        if(isRaw==true)
        {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if(params != nil)
            {
                let sendData = try? JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
                
//                let string = String.init(data: sendData!, encoding: .utf8)
//                print("string: \(string!)")
                request.httpBody=sendData!
            }
        }
        else
        {
            if(params != nil)
            {
                let boundary = "0xKhTmLbOuNdArY";
                
                let contentType = "multipart/form-data; boundary=\(boundary)";
                
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
                
                var body:Data = Data()
                
                for (key, value) in params!
                {
                    if(value is UIImage)
                    {
                        let image = value as! UIImage
                        let imageData = image.jpegData(compressionQuality: 1.0)
                        
                        if(imageData != nil)
                        {
                            body.append(Data("--\(boundary)\r\n".utf8))
                            
                            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"; filename=\"image.jpg\"\r\n".utf8))
                            
                            body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
                            
                            body.append(imageData!)
                            
                            body.append(Data("\r\n".utf8))
                        }
                        
                        body.append(Data("--\(boundary)--\r\n".utf8))
                    }
                    else
                    {
                        body.append(Data("--\(boundary)\r\n".utf8))
                        
                        body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                        
                        body.append(Data("\(String(describing: value))\r\n".utf8))
                    }
                }
                
//                let string = String.init(data: body, encoding: .utf8)
//                print("string: \(string!)")
                request.httpBody=body
            }
        }
        
        return request
    }
    
    // MARK:- Network checking
    
    private func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    }
    
    // MARK:- Show/hide default newtork loader of device
    
    private func setNetworkActivityIndicatorVisible(_ visible:Bool)
    {
        if(visible)
        {
            numberOfDeviceLoading += 1
        }
        else
        {
            numberOfDeviceLoading -= 1
        }
        
        DispatchQueue.main.async {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = (self.numberOfDeviceLoading > 0)
        }
    }
    
    // MARK:- - Show/hide hud loader when call API
    
    func setHudLoaderVisible(_ setVisible: Bool)
    {
        if (setVisible)
        {
            numberOfHudLoading += 1
        }
        else
        {
            numberOfHudLoading -= 1
        }
        if (numberOfHudLoading > 0)
        {
            self.showHud()
        }
        else
        {
            self.hideHud()
        }
    }
    
    private func showHud()
    {
        if (UIApplication.shared.keyWindow != nil)
        {
            let window = UIApplication.shared.keyWindow!;
            window.makeKeyAndVisible()
            ProgressHud.shareHud.showInView(view: window)
        }
        else if (UIApplication.shared.delegate?.window != nil)
        {
            let window = ((UIApplication.shared.delegate?.window)!)!;
            window.makeKeyAndVisible();
            ProgressHud.shareHud.showInView(view: window);
        }
        else
        {
            let array = UIApplication.shared.windows;
            if (array.count != 0)
            {
                array[0].makeKeyAndVisible();
                ProgressHud.shareHud.showInView(view: array[0]);
            }
        }
    }
    
    private func hideHud()
    {
        ProgressHud.shareHud.hide()
    }
    
    // MARK:- Databse Copy & Checking
    
    /// Copy database from project to document of sandbox
    /// - Returns: True - copy success or database is existed. False - problem with copy process
    func copyDatabaseIfNeeded() -> Bool
    {
        if(!self.checkDatabase())
        {
            return self.copyDatabase()
        }
        else
        {
            return true
        }
    }
    
    func checkDatabase() -> Bool
    {
        /// Get document folder of application
        let documentPath =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        /// Build database path
        dbPath = documentPath + "/" + DB_NAME
        
        return FileManager.default.fileExists(atPath: dbPath)
    }
    
    func copyDatabase() -> Bool
    {
        /// Get db path in this project
        let localPath = Bundle.main.resourcePath! + "/" + DB_NAME
        
        var success = false
        
        /// Copy db from this project to document of sandbox
        do {
            try FileManager.default.copyItem(atPath: localPath, toPath: dbPath)
            
            success = true
        }
        catch
        {
            print("Error copy db file")
        }
        
        return success
    }
    
    // MARK:- SQL base function
    
    func closeDb()
    {
        sqlite3_close(db)
    }
    
    func executeSql(_ sqlString:String, callBack:@escaping (_ success:Bool, _ message:String)->Void)
    {
        /// Change to background thread
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            var success = false
            var message = ""
            
            /// Check if we can open database
            if(sqlite3_open(self.dbPath, &self.db) == SQLITE_OK)
            {
                /// Check executed status
                if(sqlite3_exec(self.db, sqlString, nil, nil, nil) != SQLITE_OK)
                {
                    message = "Fail to execute sql: \(sqlString)"
                }
                else
                {
                    success = true
                    message = "succed to execute sql: \(sqlString)"
                }
                
                self.closeDb()
            }
            else
            {
                message = "Can't open databae"
            }
            
            /// Change to UI thread
            DispatchQueue.main.async(execute: {
                
                callBack(success, message)
            })
        }
    }
    
    func selectDataWithSql(_ sqlString:String, callBack:@escaping (_ success:Bool, _ queryStatement:OpaquePointer?, _ message:String)->Void)
    {
        /// Change to background thread
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            var success = false
            var message = ""
            var queryStatement: OpaquePointer? = nil
            
            /// Check if we can open database
            if(sqlite3_open(self.dbPath, &self.db) == SQLITE_OK)
            {
                if(sqlite3_prepare(self.db, sqlString, -1, &queryStatement, nil) != SQLITE_OK)
                {
                    message = "Fail to select with Sql: \(sqlString)"
                }
                else
                {
                    success = true
                    message = "Succed to select with Sql: \(sqlString)"
                }
            }
            else
            {
                message = "Can't open databae"
            }
            
            /// Change to UI thread
            DispatchQueue.main.async(execute: {
                
                callBack(success, queryStatement, message)
                
                sqlite3_finalize(queryStatement)
                self.closeDb()
            })
        }
    }
    
    // MARK:- Utils
    
}
