//
//  ParseClient.swift
//  OnTheMap
//
//  Created by admin on 1/10/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation

class ParseClient {
    
    static let shared = ParseClient()
    
    func encodeParameters(params: [String: AnyObject]) -> String {
        let components = NSURLComponents()
        components.queryItems = params.map { (NSURLQueryItem(name: $0, value: String($1 as! String)) as URLQueryItem) }
        
        return components.percentEncodedQuery ?? ""
    }
    
    func getStudentLocations(completionHandler: @escaping (_ students: [ParseStudent]?, _ error: String?) -> Void) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        let params: [String: AnyObject] = ["limit": "100" as AnyObject, "order": "-updatedAt" as AnyObject]
        let url = urlString + "?" + encodeParameters(params: params)
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
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

            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(nil, "Error while JSON parsing")
                return
            }

            guard ((parsedResult["error"] as? String) == nil) else {
                completionHandler(nil, parsedResult["error"] as? String)
                return
            }

            guard let studentLocations = parsedResult["results"] as? [[String : AnyObject ]] else {
                completionHandler(nil, "Can't find results in response")
                return
            }

            var students = [ParseStudent]()

            for location in studentLocations {
                students.append(ParseStudent(dictionary: location))
            }
            completionHandler(students, nil)
        }
        task.resume()
    }
    
    func getStudentLocation(uniqueKey: String, completionHandler: @escaping (_ student: ParseStudent?, _ error: String?) -> Void) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
        let params: [String: AnyObject] = ["where": "{\"uniqueKey\":\"\(uniqueKey)\"}" as AnyObject]
        let url = urlString + "?" + encodeParameters(params: params)
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
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
            
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                completionHandler(nil, "Error while JSON parsing")
                return
            }
            
            guard let studentLocation = parsedResult["results"] as? [[String : AnyObject ]] else {
                completionHandler(nil, "Can't find results in response")
                return
            }
            
            if let dictionary = studentLocation.first {
                completionHandler(ParseStudent(dictionary: dictionary), nil)
            } else {
                completionHandler(nil, nil)
            }
        }
        task.resume()
    }
    
    func postStudentLocation(student: ParseStudent, completionHandler: @escaping (_ error: String?) -> Void) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaUrl)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler("\(String(describing: error))")
                return
            }
            
            guard data != nil else {
                completionHandler("No data!")
                return
            }
            
            completionHandler(nil)
        }
        task.resume()
    }
    
    func putStudentLocation(student: ParseStudent, completionHandler: @escaping (_ error: String?) -> Void) {
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(student.objectId)"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaUrl)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler("\(String(describing: error))")
                return
            }
            
            guard data != nil else {
                completionHandler("No data!")
                return
            }
            
            completionHandler(nil)
        }
        task.resume()
    }
    
}
