//
//  EventsViewController.swift
//  ckcc
//
//  Created by Bun Leap on 11/5/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import SDWebImage

class EventsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var eventsTableView: UITableView!
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventNib = UINib(nibName: "EventTableViewCell", bundle: nil)
        
        eventsTableView.register(eventNib, forCellReuseIdentifier: "event_cell")
        
        eventsTableView.dataSource = self
        
        let url = URL(string: "http://test.js-cambodia.com/ckcc/events.php")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let array = try! jsonDecoder.decode([Event].self, from: data!)
            self.events = array
            
            DispatchQueue.main.async {
                self.eventsTableView.reloadData()
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "event_cell") as! EventTableViewCell
        
    
        
        cell.titleLabel.text = events[indexPath.row].title
        
        let imageUrl = events[indexPath.row].imageUrl
        cell.eventImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "default"))
        return cell
        
    }
}
