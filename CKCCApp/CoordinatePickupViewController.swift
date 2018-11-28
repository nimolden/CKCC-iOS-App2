//
//  CoordinatePickupViewController.swift
//  CKCCApp
//
//  Created by Bun Leap on 11/28/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import GoogleMaps

class CoordinatePickupViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var selectedCoordinate: CLLocationCoordinate2D!
    
    var locationManager: CLLocationManager!
    var userMarker: GMSMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        // Initialize marker
        userMarker = GMSMarker()
        userMarker.icon = #imageLiteral(resourceName: "ic_user_marker")
        userMarker.map = mapView
        
        // Initialize locationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Load user's current position
        
        let lastKnowLocation = locationManager.location
        if lastKnowLocation != nil {
            moveMap(coordinate: lastKnowLocation!.coordinate)
        }
        
        // Request user permission
        locationManager.requestAlwaysAuthorization()
        
    }

    // Location Delegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            Utility.showAlertMessage(title: "Error", message: "This app cannot work properly without location permission.", inViewController: self)
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            requestLocationUpdate()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        let newLocation = locations.first!
        moveMap(coordinate: newLocation.coordinate)
        // Remove location update
        locationManager.stopUpdatingLocation()
    }
    
    // Map Delegate
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("User long press at lat: ", coordinate.latitude, ", lng: ", coordinate.longitude)
        selectedCoordinate = coordinate
        performSegue(withIdentifier: "unwind_segue_map", sender: nil)
    }
    
    
    private func requestLocationUpdate(){
        print("requestLocationUpdate")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
    }
    
    private func moveMap(coordinate: CLLocationCoordinate2D){
        let cameraPosition = GMSCameraPosition(target: coordinate, zoom: 14, bearing: 0, viewingAngle: 0)
        mapView.animate(to: cameraPosition)
        userMarker.position = coordinate
    }

}

















