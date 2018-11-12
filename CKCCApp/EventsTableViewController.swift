//
//  EventsViewController.swift
//  ckcc
//
//  Created by Bun Leap on 11/5/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseStorage

class EventsTableViewController: UITableViewController {

    var events = [Event]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let eventNib = UINib(nibName: "EventTableViewCell", bundle: nil)
        
        tableView.register(eventNib, forCellReuseIdentifier: "event_cell")
        
        refreshControl?.layoutIfNeeded()
        refreshControl?.beginRefreshing()
        let point = CGPoint(x: 0, y: -refreshControl!.frame.size.height)
        tableView.setContentOffset(point, animated: true)
        //loadDataFromServer()
        loadDataFromFirestore()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! EventDetailViewController
        let event = events[selectedIndex]
        destinationVc.event = event
    }
    
    // MARK: - IBActions
    
    @IBAction func onRefreshControllPulled(_ sender: Any) {
        // loadDataFromServer()
        // loadDataFromFirestore()
    }
    
    
    // MARK: - DataSource
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
    
    // MARK: - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "segue_event_detail", sender: nil)
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
    
    private func loadDataFromFirestore(){
        print("loadDataFromFirestore")
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        db.collection("events").addSnapshotListener { (querySnapshot, error) in
        // db.collection("events").getDocuments { (querySnapshot, error) in
            // Convert query snapshot to array of Event
            var array = [Event]()
            for document in querySnapshot!.documents {
                let title = document.data()["title"] as! String
                //let date = document.data()["date"] as! String
                //let location = document.data()["location"] as! String
                let imageUrl = document.data()["imageUrl"] as! String
                let event = Event(id: document.documentID, title: title, imageUrl: imageUrl)
                array.append(event)
            }
            self.events = array
            
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
}
















