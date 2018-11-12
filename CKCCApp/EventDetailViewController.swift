//
//  EventDetailViewController.swift
//  CKCCApp
//
//  Created by Bun Leap on 11/12/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = event.title
        eventImageView.sd_setImage(with: URL(string: event.imageUrl), placeholderImage: UIImage(named: "default"))
        titleLabel.text = event.title
        dateLabel.text = "11 Nov 2018"
    }

}
