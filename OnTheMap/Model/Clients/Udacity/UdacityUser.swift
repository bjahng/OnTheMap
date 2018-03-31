//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by admin on 1/22/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation

struct UdacityUser {
    
    var uniqueKey: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(dictionary: [String : AnyObject]) {
        uniqueKey = dictionary["uniqueKey"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
    }
}
