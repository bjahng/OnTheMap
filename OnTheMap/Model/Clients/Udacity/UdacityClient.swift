//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by admin on 1/9/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation

class UdacityClient {
    
    static let shared = UdacityClient()
    var sessionID: String?
    var accountKey: String?
    
    func getUdacitySession(username: String, password: String, completionHandler: @escaping (_ success: Bool, _ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard (error == nil) else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            
            guard let data = data else {
                completionHandler(false, "No data!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandler(false, "Error while JSON parsing")
                return
            }
            
            guard ((parsedResult["error"] as? String) == nil) else {
                completionHandler(false, parsedResult["error"] as? String)
                return
            }
            
            guard let session = parsedResult!["session"] as? [String : AnyObject], let sessionID = session["id"] as? String else {
                completionHandler(false, "Can't find session ID")
                return
            }
            
            guard let key = parsedResult["account"]!["key"] as? String else {
                completionHandler(false, "Can't find account key")
                return
            }
            
            self.accountKey = key
            self.sessionID = sessionID
            completionHandler(true, nil)
        }
        task.resume()
    }
    
    func deleteUdacitySession(completionHandler: @escaping (_ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard (error == nil) else {
                completionHandler(error as? String)
                return
            }
            
            guard let data = data else {
                completionHandler("No data!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandler("Error while JSON parsing")
                return
            }
            
            guard ((parsedResult["error"] as? String) == nil) else {
                completionHandler(parsedResult["error"] as? String)
                return
            }
            
            guard let session = parsedResult!["session"] as? [String : AnyObject], let sessionID = session["id"] as? String else {
                completionHandler("Can't find session ID")
                return
            }
            
            self.sessionID = sessionID
            self.accountKey = nil
            completionHandler(nil)
        }
        task.resume()
    }
    
    func getUdacityUser(accountKey: String, completionHandler: @escaping (_ user: UdacityUser?, _ error: String?) -> Void) {
        
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/\(accountKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard (error == nil) else {
                completionHandler(nil, error as? String)
                return
            }
            
            guard let data = data else {
                completionHandler(nil, "No data!")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            let parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completionHandler(nil, "Error while JSON parsing")
                return
            }
            
            guard ((parsedResult["error"] as? String) == nil) else {
                completionHandler(nil, parsedResult["error"] as? String)
                return
            }
            
            guard let userData = parsedResult["user"] as? [String: AnyObject] else {
                completionHandler(nil, "Can't find user in response!")
                return
            }
            
            guard let firstName = userData["first_name"] as? String, let lastName = userData["last_name"] as? String else {
                completionHandler(nil, "Can't find user first_name or last_name in response")
                return
            }
            
            let user = UdacityUser(dictionary: [
                "uniqueKey": accountKey as AnyObject,
                "firstName": firstName as AnyObject,
                "lastName": lastName as AnyObject,
                ])
            
            completionHandler(user, nil)
        }
        task.resume()
    }
    
}
