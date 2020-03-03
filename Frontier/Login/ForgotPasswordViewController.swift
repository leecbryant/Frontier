//
//  LoginViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/24/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var Email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        if(Email.text != "") {
            if(isValidEmail(emailStr: Email.text!)) {
                createAlert(title: "Success", message: "If your account exists, an email has been dispatched with instructions on how to reset your password.", success: true)
            } else {
                createAlert(title: "Error", message: "Must provide valid email.", success: false)
            }
        } else {
            createAlert(title: "Error", message: "Must provide an email.", success: false)
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
