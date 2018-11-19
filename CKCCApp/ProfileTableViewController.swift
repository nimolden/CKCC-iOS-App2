//
//  ProfileTableViewController.swift
//  CKCCApp
//
//  Created by Bun Leap on 11/19/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.sum(number1: 5, number2: 6) { (result) in
            print("Result: ", result)
        }
        
        print("Hello")
        
        loadProfileInfo()
    }
    
    private func loadProfileInfo(){
        let parameters = ["fields": "id,name,birthday,gender,location,email"]
        let request = FBSDKGraphRequest(graphPath: "/me", parameters: parameters)
        request?.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("Load profile info error: ", error!.localizedDescription)
            } else {
                print("Load profile info success")
                let resultDictionry = result as! [String: Any]
                self.nameLabel.text = resultDictionry["name"] as? String
                self.dobLabel.text = resultDictionry["birthday"] as? String
                self.genderLabel.text = resultDictionry["gender"] as? String
                self.emailLabel.text = resultDictionry["email"] as? String
                let locationDictionary = resultDictionry["location"] as! [String: Any]
                self.addressLabel.text = locationDictionary["name"] as? String
                
                let id = resultDictionry["id"] as! String
                let profileImageUrl = URL(string: "https://graph.facebook.com/\(id)/picture?type=large")
                print("https://graph.facebook.com/\(id)/picture?type=large")
                self.profileImageView.sd_setImage(with: profileImageUrl, completed: nil)
            }
        })
    }

    @IBAction func onSignoutButtonClick(_ sender: Any) {
        FBSDKLoginManager().logOut()
        dismiss(animated: true, completion: nil)
    }
}







