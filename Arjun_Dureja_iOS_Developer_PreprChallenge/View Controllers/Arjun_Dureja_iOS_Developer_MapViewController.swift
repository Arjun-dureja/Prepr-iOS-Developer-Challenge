//
//  MapViewController.swift
//  Arjun_Dureja_iOS_Developer_PreprChallenge
//
//  Created by Arjun Dureja on 2020-05-08.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {
    var lab: Lab?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Remove large titles
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Confirm that vc was sent a lab
        guard let lab = lab else { return }
        
        title = lab.name
        
        // Styling
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.customGreen]
        
        // Set map camera position to the lab location
        let camera = GMSCameraPosition.camera(withLatitude: lab.latitude, longitude: lab.longitude, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! - 10, width: self.view.frame.width, height: self.view.frame.height - (self.navigationController?.navigationBar.frame.height)! + 10), camera: camera)
        self.view.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lab.latitude, longitude: lab.longitude)
        
        // Sets marker title
        marker.title = lab.locationName
        marker.map = mapView
    }

}
