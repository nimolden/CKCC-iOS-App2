//
//  Utility.swift
//  CKCCApp
//
//  Created by Bun Leap on 11/14/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import Foundation
import UIKit

struct Utility {
    
    static func showAlertMessage(title: String, message: String, inViewController vc: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertMessage(title: String, message: String, withOkAction okAction: UIAlertAction, inViewController vc: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    static func sum(number1: Int, number2: Int, completion: @escaping (Int) -> Swift.Void) {
        let result = number1 + number2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            completion(result)
        }
    }
    
}
