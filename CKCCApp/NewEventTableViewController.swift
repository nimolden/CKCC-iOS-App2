//
//  NewEventTableViewController.swift
//  ckcc
//
//  Created by Bun Leap on 11/5/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class NewEventTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

   @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var saveButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable user to click on ImageView
        eventImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onEventImageViewClick))
        eventImageView.addGestureRecognizer(tapGesture)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("User picked an image.")
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        eventImageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func onEventImageViewClick(){
        // Open gallery
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonClick(_ sender: Any) {
        
        // Upload image to Firebase Storage
        print("Start upload image...")
        showLoading(state: true)
        let storage = Storage.storage()
        let imageFilName = Date().timeIntervalSince1970.description + ".png"
        let imageFullPath = "images/\(imageFilName)"
        let imageRef = storage.reference(withPath: imageFullPath)
        let imageData = UIImagePNGRepresentation(eventImageView.image!)!
        imageRef.putData(imageData, metadata: nil) { (metaData, error) in
            print("Upload image success.")
            print("Get image url...")
            imageRef.downloadURL(completion: { (url, error) in
                // Add data into Firestore
                print("Add data to Firestore")
                let title = self.titleTextField.text!
                let date = self.dateTextField.text!
                let location = self.locationTextField.text!
                let imageUrl = url!.absoluteString
                let db = Firestore.firestore()
                let eventDocument = [ "title" : title, "date" : date, "location" : location, "imageUrl" : imageUrl]
                db.collection("events").addDocument(data: eventDocument, completion: { (error) in
                    print("Add event success.")
                    DispatchQueue.main.async {
                        self.showLoading(state: false)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.showAlertMessage(title: "Success", message: "Add event success.", withOkAction: okAction)
                    }
                })
            })
        }
        
    }
    
    private func showLoading(state: Bool){
        activityIndicator.isHidden = !state
        saveButton.isHidden = state
    }
    
    private func addEventToWebService(){
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
    
    private func addEventToFirebase(){
        print("addEventToFirebase")
        let title = titleTextField.text!
        let date = dateTextField.text!
        let location = locationTextField.text!
        
        // Prepare data to add
        let newEvent = [ "title" : title, "date" : date, "location" : location, "imageUrl" : "http://test.js-cambodia.com/ckcc/images/android.png" ]
        
        // Add event to Firestore
        let db = Firestore.firestore()
        
        let ref = db.collection("eventss")
        ref.addDocument(data: newEvent) { (error) in
            print("Add completed. ", ref.collectionID)
        }
        
    }
    
    private func showAlertMessage(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertMessage(title: String, message: String, withOkAction okAction: UIAlertAction){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}


















