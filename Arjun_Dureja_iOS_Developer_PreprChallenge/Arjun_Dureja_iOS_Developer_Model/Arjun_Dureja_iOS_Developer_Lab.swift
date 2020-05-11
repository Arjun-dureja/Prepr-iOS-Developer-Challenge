//
//  Lab.swift
//  Arjun_Dureja_iOS_Developer_PreprChallenge
//
//  Created by Arjun Dureja on 2020-05-08.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import Foundation

class Lab: Codable {
    // A lab contains the following information:
    var name: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    var date: String
    
    init(name: String, locationName: String, latitude: Double, longitude: Double, date: String) {
        self.name = name
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }
}
