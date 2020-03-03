//
//  LoginViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/24/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {    
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var VerifyEmail: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var VerifyPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Submit(_ sender: Any) {
        if(FirstName.text != "" && LastName.text != "" && Email.text != "" && VerifyEmail.text != "" && Password.text != "" && VerifyPassword.text != "") {
            if(Password.text == VerifyPassword.text) {
                if(Email.text == VerifyEmail.text) {
                   createAlert(title: "Success", message: "An email has been sent with instructions on how to validate your account", success: true)
                } else {
                    createAlert(title: "Error", message: "Emails must match", success: false)
                }
            } else {
                createAlert(title: "Error", message: "Passwords must match", success: false)
            }
        } else {
            createAlert(title: "Error", message: "All fields must be filled out.", success: false)
        }
    }
    
    func createAlert(title:String, message:String, success:Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if(success) {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                (action) in alert.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }))
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                (action) in alert.dismiss(animated: true, completion: nil)
            }))
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}
