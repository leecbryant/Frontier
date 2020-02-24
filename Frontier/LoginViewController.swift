//
//  LoginViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/24/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var UsernameText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var pal: UILabel!
    
    // Loading Circle
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func login(_ sender: Any) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        if UsernameText.text == "admin" && PasswordText.text == "admin" {
            self.performSegue(withIdentifier: "loginComplete", sender: self)
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        } else {
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if UsernameText.text == "" || PasswordText.text == "" {
                if UsernameText.text == "" && PasswordText.text == "" {
                    createAlert(title: "Empty Fields", message: "Username and Password cannot be left blank.")
                }
                if UsernameText.text == "" {
                    createAlert(title: "Empty Field", message: "Username cannot be left blank.")
                }
                if PasswordText.text == "" {
                    createAlert(title: "Empty Field", message: "Password cannot be left blank.")
                }
            } else {
                createAlert(title: "Invalid Login", message: "Username or Password is incorrect.")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func registerClick(_ sender: Any) {
        self.performSegue(withIdentifier: "register", sender: self)
    }
}
