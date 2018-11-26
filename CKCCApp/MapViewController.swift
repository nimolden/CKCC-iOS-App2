//
//  MapViewController.swift
//  CKCCApp
//
//  Created by Bun Leap on 11/26/18.
//  Copyright © 2018 Cambodia-Korea Cooperation Center. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add MapView using AutoLayout
        let mapView = GMSMapView()
        view.addSubview(mapView)
        
        // Add constraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        // Add MapView using FrameBase
        /*let frame = CGRect(x: 0, y: 0, width: 200, height: 500)
        let mapView = GMSMapView(frame: frame)
        view.addSubview(mapView)*/
        
    }

    

}
