//
//  TabBarController.swift
//  OnTheMap
//
//  Created by admin on 1/9/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButtonPressed(nil)
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        UdacityClient.shared.deleteUdacitySession() { (error) in
            performUIUpdatesOnMain {
                if let error = error {
                    self.displayAlert(error)
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any?) {
        
        ParseClient.shared.getStudentLocations() { (students, error) -> Void in
            performUIUpdatesOnMain {
                guard (error == nil) else {
                    return
                }
                
                StudentInformation.shared.students = students!
                
                (self.viewControllers![0] as! MapViewController).generateMap()
                (self.viewControllers![1] as! TableViewController).generateList()
            }
        }
    }
    
    @IBAction func addPinButtonPressed(_ sender: Any) {
        ParseClient.shared.getStudentLocation(uniqueKey: UdacityClient.shared.accountKey!) { (student, error) in
            performUIUpdatesOnMain {
                guard error == nil else {
                    self.displayAlert(error!)
                    return
                }

                StudentInformation.shared.student = student
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyBoard.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
                
                if student == nil {
                    self.present(controller, animated: true, completion: nil)
                } else {
                    self.displayAlertWithTwoActions(message: "User \"\(student!.fullName)\" already has a pinned location! Would you like to overwrite it?", actionButtonTitle: "Overwrite") { (action) in
                        self.present(controller, animated: true, completion: nil)
                    }
                }
            }
        }
    }

}
