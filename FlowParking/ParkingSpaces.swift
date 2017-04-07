//
//  ParkingSpaces.swift
//  FlowParking
//
//  Created by Pavlos Nicolaou and Diana Karina Vainberg Gauna on 28/03/2017.
//  Copyright © 2017 Pavlos Nicolaou and Diana Karina Vainberg Gauna. All rights reserved.
//
//  PakringSpace object is created to add coordinates of a parking space so we can draw them on the map to look nice
//

import MapKit

@objc class ParkingSpace: NSObject {
    var coordinates: [CLLocationCoordinate2D]
    
    init(c1: CLLocationCoordinate2D, c2: CLLocationCoordinate2D, c3: CLLocationCoordinate2D, c4: CLLocationCoordinate2D) {
        self.coordinates = [c1, c2, c3, c4]
    }
}

