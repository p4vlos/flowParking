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
    
    var spaces: [[ParkingSpace]] = [[51.29665, 1.065107],//First Parking space
        [51.296675, 1.065162],
        [51.296659, 1.065182],
        [51.296634, 1.065127],
        [51.296658, 1.065181],
        [51.296633, 1.065128],//Second Pakring space
        [51.296635, 1.065126],
        [51.296616, 1.065144],
        [51.296641, 1.065202]] as [[CLLocationCoordinate2D]]

    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    static func getParkingSpaces() -> [[ParkingSpace]] {
    
        guard let path = Bundle.main.path(forResource: "ParkingSpaces", ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }

        var parkingSpaces = [[ParkingSpace]]()

        for item in array {

                let dictionary = item as? [String : Any]
                let latitude = dictionary?["latitude"] as? Double ?? 0,
                longitude = dictionary?["longitude"] as? Double ?? 0
                let parkingSpace = ParkingSpace(coordinate: CLLocationCoordinate2DMake(latitude, longitude))
                parkingSpaces[0].append(parkingSpace)
                print("\(parkingSpace)")
            }

        return parkingSpaces as [[ParkingSpace]]
    }
}

extension ParkingSpace: MKAnnotation { }
