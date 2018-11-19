//
//  LoginViewController.swift
//  CKCCApp
//
//  Created by Bun Leap on 11/14/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set facebook permission
        facebookLoginButton.readPermissions = ["email", "user_birthday", "user_gender", "user_location"]
        facebookLoginButton.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "segue_main", sender: nil)
        }
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if result.token == nil {
            Utility.showAlertMessage(title: "Error", message: "Login with Facebook error.", inViewController: self)
            print("Login with Facebook error: ", error.localizedDescription)
        } else {
            // Pass Facebook token to Firebase
            let credential = FacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                self.performSegue(withIdentifier: "segue_main", sender: nil)
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    
    
}
