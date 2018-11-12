//
//  ViewController.swift
//  CKCCApp
//
//  Created by Bun Leap on 11/12/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addEventToFirebase()
    }

    private func addEventToFirebase(){
        print("addEventToFirebase")
        let title = "Water Festival"
        let date = "abc"
        let location = "xyz"
        
        // Prepare data to add
        let newEvent = [ "title" : title, "date" : date, "location" : location, "imageUrl" : "http://test.js-cambodia.com/ckcc/images/android.png" ]
        
        // Add event to Firestore
        let db = Firestore.firestore()
        
        let ref = db.collection("eventss")
        ref.addDocument(data: newEvent) { (error) in
            print("Add completed. ", ref.collectionID)
        }
        
    }

}

