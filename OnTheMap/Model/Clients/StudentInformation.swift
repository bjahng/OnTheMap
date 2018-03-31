//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by admin on 1/16/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    static var shared = StudentInformation()
    private init() {}
    
    var user: UdacityUser?
    
    var student: ParseStudent?
    
    var students = [ParseStudent]()
    
}
