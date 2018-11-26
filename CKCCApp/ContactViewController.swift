//
//  ContactViewController.swift
//  CKCCApp
//
//  Created by Bun Leap on 11/26/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import GoogleMaps

class ContactViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Asign delegate to MapView
        mapView.delegate = self
        
        // Get last known location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let lastKnownLocation = locationManager.location
        if lastKnownLocation == nil {
            print("Cant get last known location.")
        } else {
            // Move camera to last known location
            let lastKnownLocationCameraPosition = GMSCameraPosition(target: lastKnownLocation!.coordinate, zoom: 14, bearing: 0, viewingAngle: 0)
            mapView.animate(to: lastKnownLocationCameraPosition)
            
            // Add marker to last known location
            let marker = GMSMarker(position: lastKnownLocation!.coordinate)
            marker.title = "You are here!"
            marker.map = mapView
        }
        
        // Request location privacy from user
        locationManager.requestAlwaysAuthorization()
        
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        let newMarker = GMSMarker(position: coordinate)
        newMarker.title = "Your Address"
        newMarker.isDraggable = true
        newMarker.map = mapView
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("User tap on marker: ", marker.title!)
        
        return false
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            Utility.showAlertMessage(title: "Location Privacy", message: "The app cant work properly because you did not allow location privacy. Please go to Settings to allow.", inViewController: self)
            return
        } else if status == .authorizedWhenInUse {
            print("User allowed when in use.")
        } else {
            print("User allowed always.")
        }
        requestLocationUpdate()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    private func requestLocationUpdate(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
    }

}




















