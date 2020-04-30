//
//  SupportViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 11/24/19.
//  Copyright © 2019 Lee Bryant. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Email: UITextField!
    var activityView: UIActivityIndicatorView?

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func onSubmit(_ sender: Any) {
    activityIndicator.center = self.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = UIActivityIndicatorView.Style.gray
    
    view.addSubview(activityIndicator)
    
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
        if Name.text == "" || Email.text == "" || comments.text == "" {
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
            
            if comments.text == "" {
                createAlert(title: "Empty Field", message: "Comments cannot be left blank.")
            }
        } else {
            UIApplication.shared.endIgnoringInteractionEvents()
            activityIndicator.stopAnimating()
            if isValidEmail(emailStr: Email.text!) {
                // Stop everything to load
                UIApplication.shared.beginIgnoringInteractionEvents()
                showActivityIndicator()
                // Data Structs
                struct ToDoResponseModel: Codable {
                    var Name: String?
                    var Email: String?
                    var Comments: String?
                }
                struct ReturnModel: Codable {
                    var success: Bool?
                }
                // Begin Call
                let url = URL(string: Constants.config.apiLink + "api/base/support")
                guard let requestUrl = url else { fatalError() }
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "POST"
                // Set HTTP Request Header
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let newTodoItem = ToDoResponseModel(Name: Name.text, Email: Email.text, Comments: comments.text)
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
                                        self.createAlert(title: "Error", message: "Error submitting support ticket")
                                    } else {
                                        self.Name.text = ""
                                        self.Email.text = ""
                                        self.comments.text = ""
                                        self.createAlert(title: "Support Request", message: "A ticket has been created and sent to the admins.")
                                    }
                                }
                        } catch let jsonErr {
                            print(jsonErr)
                       }
                 
                }
                task.resume()
            } else {
                createAlert(title: "Invalid Email", message: "Email must be in proper format.")
            }
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
        // Do any additional setup after loading the view.
        navigationItem.title = "Support"
        
        // Text field setup
        Name.delegate = self
        Name.tag = 0
        Name.returnKeyType = UIReturnKeyType.next
        Email.delegate = self
        Email.tag = 1
        Email.returnKeyType = UIReturnKeyType.next
        // Comments box setup
        // Set border around comment text area
        comments.layer.borderWidth = 0.8
        comments.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        comments.layer.cornerRadius = 5.0
        comments.clipsToBounds = true
        // Set placeholder for comment text area
        comments.text = "Comments"
        comments.textColor = .lightGray
        comments.returnKeyType = .done
        comments.delegate = self
        comments.tag = 3
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextView {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.onSubmit((Any).self)
        }
        return false
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
