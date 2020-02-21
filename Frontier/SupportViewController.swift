//
//  SupportViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/24/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Email: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func onSubmit(_ sender: Any) {
    activityIndicator.center = self.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = UIActivityIndicatorView.Style.gray
    
    view.addSubview(activityIndicator)
    
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
        if Name.text == "" || Email.text == "" {
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if Name.text == "" && Email.text == "" {
                createAlert(title: "Empty Fields", message: "Name and Email cannot be left blank.")
            }
            if Name.text == "" {
                createAlert(title: "Empty Field", message: "Name cannot be left blank.")
            }
            if Email.text == "" {
                createAlert(title: "Empty Field", message: "Email cannot be left blank.")
            }
        } else {
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.stopAnimating()
            if isValidEmail(emailStr: Email.text!) {
                createAlert(title: "Support Request", message: "A ticket has been created and sent to the admins.")
                Name.text = ""
                Email.text = ""
            } else {
                createAlert(title: "Invalid Email", message: "Email must be in proper format.")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Support"
        
        // Set border around comment text area
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        comments.layer.borderWidth = 0.5
        comments.layer.borderColor = borderColor.cgColor
        comments.layer.cornerRadius = 5.0
        // Set placeholder for comment text area
        comments.text = "Comments"
        comments.textColor = .lightGray
        comments.returnKeyType = .done
        comments.delegate = self
    }
    
    // Text View Delegates -- Allows placeholder in textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        if comments.text == "Comments" {
            comments.text = ""
            if #available(iOS 13.0, *) {
                 comments.textColor = UIColor.label
            } else {
                 comments.textColor = .white
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if comments.text == "" {
            comments.text = "Comments"
            comments.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}
