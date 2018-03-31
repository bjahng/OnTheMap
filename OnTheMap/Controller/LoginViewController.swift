//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by admin on 1/5/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        buttonEnabled(true, activityIndicator: activityIndicator, button: loginButton)
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert("Empty email address or password!")
        } else {
            completeLogin()
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if let url = URL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func completeLogin() {
        buttonEnabled(false, activityIndicator: activityIndicator, button: loginButton)
        
        UdacityClient.shared.getUdacitySession(username: emailTextField.text!, password: passwordTextField.text!) { (success, error) in
            performUIUpdatesOnMain {
                if success {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyBoard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                } else {
                    self.displayAlert(error!)
                    self.buttonEnabled(true, activityIndicator: self.activityIndicator, button: self.loginButton)
                }
            }
        }
    }
    
}
