//
//  Edge.swift
//  FlowParking
//
//  Created by Diana Karina Vainberg Gauna and Pavlos Nicolaou on 06/04/2017.
//  Copyright © 2017 Diana Karina Vainberg Gauna and Pavlos Nicolaou. All rights reserved.
//
//  This class defines an edge of the parking space, which is conformed by two pairs of coordinates.
//

import UIKit
import MapKit

class Edge {
    
    let point1: CLLocationCoordinate2D
    let point2: CLLocationCoordinate2D
    
    init(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D){
        self.point1 = point1
        self.point2 = point2
    }
}
