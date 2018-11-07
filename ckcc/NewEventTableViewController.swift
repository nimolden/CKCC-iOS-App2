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
        
        uploadImageToStorage()
        //addEventToFirebase()
        
    }
    
    private func uploadImageToStorage(){
        print("uploadImageToStorage")
        let storage = Storage.storage()
        let imageRef = storage.reference(withPath: "/images/event1.png")
        let imageData = UIImagePNGRepresentation(eventImageView.image!)
        imageRef.putData(imageData!, metadata: nil) { (metaData, error) in
            if error == nil {
                print("Upload image success.")
            } else {
                print("Upload image fail.")
            }
        }
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
        //let settings = db.settings
        //settings.areTimestampsInSnapshotsEnabled = true
        //db.settings = settings
        
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
    
}


















