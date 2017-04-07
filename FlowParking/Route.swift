//
//  Route.swift
//  FlowParking
//
//  Created by Pavlos Nicolaou and Diana Karina Vainberg Gauna on 04/04/2017.
//  Copyright © 2017 Diana Karina Vainberg Gauna and Pavlos Nicolaou. All rights reserved.
//
//  Route Object is created to add the coordinates of the route line to a free parking space
//  and also the coordinates for the parking space so we can show that it is free
//

import MapKit

@objc class Route: NSObject {
    var coordinates: [CLLocationCoordinate2D]
    
    init(edge1: CLLocationCoordinate2D, edge2: CLLocationCoordinate2D, edge3: CLLocationCoordinate2D, edge4: CLLocationCoordinate2D, edge5: CLLocationCoordinate2D) {
        self.coordinates = [edge1, edge2, edge3, edge4, edge5]
    }
}
