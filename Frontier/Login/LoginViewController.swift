//
//  LoginViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/24/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var UsernameText: UITextField!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var pal: UILabel!
    var activityView: UIActivityIndicatorView?

    
    @IBAction func login(_ sender: Any) {
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
            // Stop everything to load
            UIApplication.shared.beginIgnoringInteractionEvents()
            showActivityIndicator()
            // Data Structs
            struct ToDoResponseModel: Codable {
                var Username: String?
                var Password: String?
            }
            struct ReturnModel: Codable {
                var auth: Bool?
                var token: String?
            }
            // Begin Call
            let url = URL(string: Constants.config.apiLink + "api/users/login")
            guard let requestUrl = url else { fatalError() }
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let newTodoItem = ToDoResponseModel(Username: UsernameText.text?.lowercased(), Password: PasswordText.text)
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
                                if todoItemModel.auth == nil || todoItemModel.auth == false {
                                    self.createAlert(title: "Invalid Login", message: "Invalid Username or Password")
                                } else {
                                    self.performSegue(withIdentifier: "loginComplete", sender: self)
                                    // NEED to ADD way to carry token after receiving from server
                                }
                            }
                    } catch let jsonErr {
                        print(jsonErr)
                   }
             
            }
            task.resume()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text field setup
        UsernameText.delegate = self
        UsernameText.tag = 0
        UsernameText.returnKeyType = UIReturnKeyType.next
        
        PasswordText.delegate = self
        PasswordText.tag = 1
        PasswordText.returnKeyType = UIReturnKeyType.done
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.login((Any).self)
        }
        return false
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func registerClick(_ sender: Any) {
        self.performSegue(withIdentifier: "register", sender: self)
    }
    
    @IBAction func forgotClick(_ sender: Any) {
         self.performSegue(withIdentifier: "forgotPassword", sender: self)
    }
    
    @IBAction func unwindToLogout(_ unwindSegue: UIStoryboardSegue) {
        UsernameText.text = ""
        PasswordText.text = ""
    }
}
