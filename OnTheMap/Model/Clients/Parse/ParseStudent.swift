//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by admin on 1/10/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation

struct ParseStudent {
    
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaUrl: String
    var latitude: Double
    var longitude: Double
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(dictionary: [String : AnyObject]) {
        objectId = dictionary["objectId"] as? String ?? ""
        uniqueKey = dictionary["uniqueKey"] as? String ?? "0000"
        firstName = dictionary["firstName"] as? String ?? "None"
        lastName = dictionary["lastName"] as? String ?? "None"
        mapString = dictionary["mapString"] as? String ?? "Nowhere"
        mediaUrl = dictionary["mediaURL"] as? String ?? "http://udacity.com"
        latitude = dictionary["latitude"] as? Double ?? 0.000
        longitude = dictionary["longitude"] as? Double ?? 0.000
    }

}
