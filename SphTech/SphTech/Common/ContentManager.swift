//
//  ContentManager.swift
//  SphTech
//
//  Created by ninh nam on 4/22/20.
//  Copyright © 2020 ninh nam. All rights reserved.
//

import UIKit

class ContentManager: NSObject {

    // MARK:- Singleton
    
    static let shareManager = ContentManager()
    
    // MARK:- Base API request
    
    /// Call all API
    /// - Parameters:
    ///   - urlString: Input url of API
    ///   - params: Params of API
    ///   - method: Http Method of API
    ///   - isRaw: Just affect with http method is differ GET. And this value depends on API input param defination
    ///   - showHud: Show loading when API calling
    ///   - completion: Data callback
    func sendBaseRequest_(urlString: String,params:[String:Any]?,method:String,isRaw:Bool,showHud:Bool,completion:@escaping (_ success:Bool,_ response:Any?,_ message:String?)->Void)
    {

        let request = self.createRequest(urlString, params: params, method: method, isRaw: isRaw)
        
        let task = URLSession.shared.dataTask(with: request!) { (data, res, error) in
            
            var success: Bool
            var message: String?
            var json: Any?
            
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
                        json = try JSONSerialization.jsonObject(with: data!)
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
            
            DispatchQueue.main.async {
                completion(success,json,message)
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
}
