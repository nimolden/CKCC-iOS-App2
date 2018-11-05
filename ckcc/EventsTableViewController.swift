//
//  EventsViewController.swift
//  ckcc
//
//  Created by Bun Leap on 11/5/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import SDWebImage

class EventsTableViewController: UITableViewController {

    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventNib = UINib(nibName: "EventTableViewCell", bundle: nil)
        
        tableView.register(eventNib, forCellReuseIdentifier: "event_cell")
        
        refreshControl?.layoutIfNeeded()
        refreshControl?.beginRefreshing()
        let point = CGPoint(x: 0, y: -refreshControl!.frame.size.height)
        tableView.setContentOffset(point, animated: true)
        loadDataFromServer()
    }
    
    // MARK: - IBActions
    
    @IBAction func onRefreshControllPulled(_ sender: Any) {
        loadDataFromServer()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "event_cell") as! EventTableViewCell
        
    
        
        cell.titleLabel.text = events[indexPath.row].title
        
        let imageUrl = events[indexPath.row].imageUrl
        cell.eventImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "default"))
        return cell
        
    }
    
    private func loadDataFromServer(){
        let url = URL(string: "http://test.js-cambodia.com/ckcc/events.php")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let array = try! jsonDecoder.decode([Event].self, from: data!)
            self.events = array
            
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
}
