//
//  DartTableViewController.swift
//  Frontier
//
//  Created by Lee Bryant on 3/6/20.
//  Copyright © 2020 Lee Bryant. All rights reserved.
//

import UIKit

class DartTableViewController: UITableViewController {
    var HorseDartData = [Treatment]()
    var activityView: UIActivityIndicatorView?
    var HorseID: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Dart Log"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return HorseDartData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dartCell", for: indexPath)
        
        switch(HorseDartData[indexPath.row].Action) {
            case "P":
                cell.textLabel?.text = "Primer"
            case "B":
                cell.textLabel?.text = "Booster"
            default:break
        }
        
        // Date Format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale   = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        guard let date = dateFormatter.date(from: HorseDartData[indexPath.row].Date) else {
            fatalError()
        }
        
        // Date date to custom string
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        let newDate = dateFormatter.string(from: date)

        cell.detailTextLabel?.text = newDate
        
        return cell
    }
    
    @IBAction func onNew(_ sender: Any) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Add New Dart", message: "Select dart type", preferredStyle: .alert)

        // Create the actions
        let primerAction = UIAlertAction(title: "Primer", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Primer Pressed")
            self.submitNewShot(type: "P")
        }
        
        // Create the actions
        let boosterAction = UIAlertAction(title: "Booster", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("Booster Pressed")
            self.submitNewShot(type: "B")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }

        // Add the actions
        alertController.addAction(primerAction)
        alertController.addAction(boosterAction)
        alertController.addAction(cancelAction)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func submitNewShot(type: String) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        // Stop everything to load
        UIApplication.shared.beginIgnoringInteractionEvents()
        showActivityIndicator()
        // Data Structs
        struct ToDoResponseModel: Codable {
            var HorseID: Int?
            var Shot: String?
        }
        struct ReturnModel: Codable {
            var success: Bool?
            var id: Int?
        }
        // Begin Call
        let url = URL(string: Constants.config.apiLink + "api/base/dart")
        guard let requestUrl = url else { fatalError() }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        // Set HTTP Request Header
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let newTodoItem = ToDoResponseModel(HorseID: HorseID, Shot: type)
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
                                self.createAlert(title: "Error", message: "Unable to create a new dart record")
                            } else {
                                self.HorseDartData.insert(Treatment(id: todoItemModel.id, HorseID: self.HorseID, Date: result, Action: type), at: 0)
                                self.tableView.reloadData()
                            }
                        }
                } catch let jsonErr {
                    print(jsonErr)
               }
         
        }
        task.resume()
    }
    
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
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
    
}
