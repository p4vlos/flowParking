//
//  ParkingSpaces.swift
//  FlowParking
//
//  Created by Pavlos Nicolaou on 28/03/2017.
//  Copyright © 2017 Pavlos Nicolaou. All rights reserved.
//

import MapKit

@objc class ParkingSpace: NSObject {
    var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    static func getParkingSpaces() -> [ParkingSpace] {
    
        guard let path = Bundle.main.path(forResource: "ParkingSpaces", ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }

        var parkingSpaces = [ParkingSpace]()

        for item in array {

                let dictionary = item as? [String : Any]
                let latitude = dictionary?["latitude"] as? Double ?? 0,
                longitude = dictionary?["longitude"] as? Double ?? 0
                let parkingSpace = ParkingSpace(coordinate: CLLocationCoordinate2DMake(latitude, longitude))
                parkingSpaces.append(parkingSpace)
                print("\(parkingSpace)")
            }

        return parkingSpaces as [ParkingSpace]
    }
}

extension ParkingSpace: MKAnnotation { }
