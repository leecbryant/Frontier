//
//  LoginViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/24/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var VerifyEmail: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var VerifyPassword: UITextField!
    var activityView: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Text field setup
        Username.delegate = self
        Username.tag = 0
        Username.returnKeyType = UIReturnKeyType.next
        FirstName.delegate = self
        FirstName.tag = 1
        FirstName.returnKeyType = UIReturnKeyType.next
        LastName.delegate = self
        LastName.tag = 2
        LastName.returnKeyType = UIReturnKeyType.next
        Email.delegate = self
        Email.tag = 3
        Email.returnKeyType = UIReturnKeyType.next
        VerifyEmail.delegate = self
        VerifyEmail.tag = 4
        VerifyEmail.returnKeyType = UIReturnKeyType.next
        Password.delegate = self
        Password.tag = 5
        Password.returnKeyType = UIReturnKeyType.next
        VerifyPassword.delegate = self
        VerifyPassword.tag = 6
        VerifyPassword.returnKeyType = UIReturnKeyType.done
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.Submit((Any).self)
        }
        return false
    }
    
    @IBAction func Submit(_ sender: Any) {
        if(Username.text != "" && FirstName.text != "" && LastName.text != "" && Email.text != "" && VerifyEmail.text != "" && Password.text != "" && VerifyPassword.text != "") {
            if(Password.text == VerifyPassword.text) {
                if(Email.text == VerifyEmail.text) {
                    if(isValidEmail(emailStr: Email.text!)) {
                       // Stop everything to load
                       UIApplication.shared.beginIgnoringInteractionEvents()
                       showActivityIndicator()
                       // Data Structs
                       struct ToDoResponseModel: Codable {
                            var Username: String?
                            var FirstName: String?
                            var LastName: String?
                            var Email: String?
                            var Password: String?
                       }
                       struct ReturnModel: Codable {
                           var success: Bool?
                       }
                       
                       // Begin Call
                       let url = URL(string: "https://f1fb8cc1.ngrok.io/api/users/register")
                       guard let requestUrl = url else { fatalError() }
                       var request = URLRequest(url: requestUrl)
                       request.httpMethod = "POST"
                       // Set HTTP Request Header
                       request.setValue("application/json", forHTTPHeaderField: "Accept")
                       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                        let newTodoItem = ToDoResponseModel(Username: Username.text?.lowercased(), FirstName: FirstName.text, LastName: LastName.text, Email: Email.text, Password: Password.text)
                       let jsonData = try? JSONEncoder().encode(newTodoItem)
                       request.httpBody = jsonData
                           let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                               
                               if let error = error {
                                   print("Error took place \(error)")
                                   return
                               }
                               guard let data = data else {return}
                               do {
                                    let todoItemModel = try JSONDecoder().decode(ReturnModel.self, from: data)
                                       DispatchQueue.main.async {
                                           UIApplication.shared.endIgnoringInteractionEvents()
                                           self.hideActivityIndicator()
                                           if todoItemModel.success == nil || todoItemModel.success == false {
                                            self.createAlert(title: "Error", message: "Something went wrong while creating account. Please try again later or contact an admin.", success: false)
                                           } else {
                                               self.createAlert(title: "Success", message: "Account registration complete.", success: true)
                                           }
                                       }
                               } catch let jsonErr {
                                   print(jsonErr)
                              }
                       }
                       task.resume()
                    } else {
                        createAlert(title: "Error", message: "Email must be valid", success: false)
                    }
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
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView()
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }

    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
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
