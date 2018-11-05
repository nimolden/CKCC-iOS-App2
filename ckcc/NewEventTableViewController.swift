//
//  NewEventTableViewController.swift
//  ckcc
//
//  Created by Bun Leap on 11/5/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit

class NewEventTableViewController: UITableViewController {

   @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBAction func onSaveButtonClick(_ sender: Any) {
        
        let title = titleTextField.text!
        let date = dateTextField.text!
        let location = locationTextField.text!
        
        // Prepare parameters to send to Server
        let dataToSubmit = "title=\(title)&date=\(date)&location=\(location)".data(using: .utf8)
        
        // Send data to Server
        let url = URL(string: "http://test.js-cambodia.com/ckcc/add-event.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = dataToSubmit
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let apiResponse = try! jsonDecoder.decode(ApiReponse.self, from: data!)
            DispatchQueue.main.async {
                if apiResponse.code == 0 {
                    // Insert success
                    self.showAlertMessage(title: "Success", message: "Add event success.")
                } else {
                    // Insert fail
                    self.showAlertMessage(title: "Error", message: "Add event fail.")
                }
            }
        }
        task.resume()
    }
    
    private func showAlertMessage(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


















