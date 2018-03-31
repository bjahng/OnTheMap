//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by admin on 1/19/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displayAlert(_ message: String, dismissButtonTitle: String = "OK") {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissButtonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayAlertWithTwoActions(message: String, dismissButtonTitle: String = "Cancel", actionButtonTitle: String = "OK", completionHandler: @escaping ((UIAlertAction!) -> Void)) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: actionButtonTitle, style: .default, handler: completionHandler))
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default) { (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        self.present(controller, animated: true, completion: nil)
    }
    
    func buttonEnabled(_ status: Bool, activityIndicator: UIActivityIndicatorView, button: UIButton) {
        if status {
            activityIndicator.stopAnimating()
            button.isEnabled = true
            button.backgroundColor = UIColor(red: 0.0, green: 174.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        } else {
            activityIndicator.startAnimating()
            button.isEnabled = false
            button.backgroundColor = UIColor(red: 0.0, green: 174.0/255.0, blue: 230.0/255.0, alpha: 0.5)
        }
    }
    
}
