//
//  AddLocationMainViewController.swift
//  OnTheMap
//
//  Created by admin on 1/5/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMainViewController: UIViewController {
    
    var coordinate: CLLocationCoordinate2D?

    @IBOutlet weak var addLocationTextField: UITextField!
    @IBOutlet weak var addWebsiteTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        buttonEnabled(true, activityIndicator: activityIndicator, button: findLocationButton)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        buttonEnabled(false, activityIndicator: activityIndicator, button: findLocationButton)
        addLocation()
    }
    
    
    func addLocation() {
        guard (addLocationTextField.text != ""), (addWebsiteTextField.text != "") else {
            displayAlert("Empty location or website!")
            buttonEnabled(true, activityIndicator: activityIndicator, button: findLocationButton)
            return
        }
        
        guard let link = NSURL(string: addWebsiteTextField.text!), UIApplication.shared.canOpenURL(link as URL) else {
            displayAlert("Invalid Link!\nPlease start with \"http://\"")
            buttonEnabled(true, activityIndicator: activityIndicator, button: findLocationButton)
            return
        }

        CLGeocoder().geocodeAddressString(addLocationTextField.text!) { (placemark, error) in
            
            guard error == nil else {
                self.displayAlert("Could not find your location!")
                self.buttonEnabled(true, activityIndicator: self.activityIndicator, button: self.findLocationButton)
                return
            }

            if let location = placemark!.first!.location {
                self.coordinate = location.coordinate
                self.performSegue(withIdentifier: "AddLocationSegue", sender: UIBarButtonItem.self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddLocationSegue" {
            
            if let coordinate = self.coordinate {
                
                let annotation = MKPointAnnotation()
                let destinationVC = segue.destination as! AddLocationMapViewController

                destinationVC.newLocation = addLocationTextField.text
                destinationVC.newWebsite = addWebsiteTextField.text
                destinationVC.newCoordinates = coordinate

                annotation.coordinate = coordinate
                annotation.title = addLocationTextField.text

                let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.01))
                
                performUIUpdatesOnMain {
                    destinationVC.mapView.addAnnotation(annotation)
                    destinationVC.mapView.setRegion(region, animated: true)
                    destinationVC.mapView.regionThatFits(region)
                }
            }
        }
    }

}
