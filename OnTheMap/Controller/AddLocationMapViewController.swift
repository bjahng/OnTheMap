//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by admin on 1/5/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: UIButton!
    
    var newLocation: String?
    var newWebsite: String?
    var newCoordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }

    @IBAction func finishButtonPressed(_ sender: Any) {
        buttonEnabled(false, activityIndicator: activityIndicator, button: finishButton)
        
        UdacityClient.shared.getUdacityUser(accountKey: UdacityClient.shared.accountKey!) { (user, error) -> Void in
            
            guard error == nil else {
                performUIUpdatesOnMain {
                    self.displayAlert("Post failed: \(error!)")
                    self.buttonEnabled(true, activityIndicator: self.activityIndicator, button: self.finishButton)
                }
                return
            }
            
            guard user != nil else {
                performUIUpdatesOnMain {
                    self.displayAlert("Post failed: No user found!")
                    self.buttonEnabled(true, activityIndicator: self.activityIndicator, button: self.finishButton)
                }
                return
            }
            
            var student = ParseStudent(dictionary: [
                "firstName": user!.firstName as AnyObject,
                "lastName": user!.lastName as AnyObject,
                "longitude": Double(self.newCoordinates!.longitude) as AnyObject,
                "latitude": Double(self.newCoordinates!.latitude) as AnyObject,
                "mediaURL": self.newWebsite as AnyObject,
                "mapString": self.newLocation as AnyObject,
                "uniqueKey": user?.uniqueKey as AnyObject,
                "objectId": "" as AnyObject,
                ])
            
            if StudentInformation.shared.student == nil {
                ParseClient.shared.postStudentLocation(student: student, completionHandler: self.studentSaveHandler)
            } else {
                student.objectId = StudentInformation.shared.student!.objectId
                ParseClient.shared.putStudentLocation(student: student, completionHandler: self.studentSaveHandler)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    private func studentSaveHandler(error: String?) {
        performUIUpdatesOnMain {
            
            guard error == nil else {
                self.displayAlert(error!)
                return
            }
            
            let navigationController = self.presentingViewController as! UINavigationController
            let tabBarController = navigationController.viewControllers.first as! TabBarController
            tabBarController.refreshButtonPressed(nil)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
