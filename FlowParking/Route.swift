//
//  Route.swift
//  FlowParking
//
//  Created by Pavlos Nicolaou on 04/04/2017.
//  Copyright © 2017 Pavlos Nicolaou. All rights reserved.
//

import MapKit

@objc class Route: NSObject {
    var coordinates: [CLLocationCoordinate2D]
    
    init(edge1: CLLocationCoordinate2D, edge2: CLLocationCoordinate2D, edge3: CLLocationCoordinate2D, edge4: CLLocationCoordinate2D, edge5: CLLocationCoordinate2D) {
        self.coordinates = [edge1, edge2, edge3, edge4, edge5]
    }
}
