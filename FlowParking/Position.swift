//
//  Position.swift
//  FlowParking
//
//  Created by Pavlos Nicolaou and Diana Karina Vainberg Gauna on 04/04/2017.
//  Copyright © 2017 Diana Karina Vainberg Gauna and Pavlos Nicolaou. All rights reserved.
//

import UIKit
import MapKit

class Position {
    
    // Beacons' locations
    static var beaconsPos: [Int: [Double]] = [42397: [51.296624, 1.064893],
                                              1819: [51.296529, 1.064997],
                                              59845: [51.296441, 1.065092],
                                              54060: [51.296356, 1.065246],
                                              34499: [51.296692, 1.065065],
                                              2627: [51.296634, 1.065126],
                                              29950: [51.296548, 1.065225],
                                              20588: [51.296458, 1.065325],
                                              11731: [51.296409, 1.065383],
                                              59879: [51.296761, 1.065229],
                                              9483: [51.296685, 1.065357],
                                              23240: [51.296592, 1.065457],
                                              25488: [51.296497, 1.065561]]
    
    static var edges = [Edge(point1: CLLocationCoordinate2D(latitude: 51.296759, longitude: 1.065430), point2: CLLocationCoordinate2D(latitude: 51.296675, longitude: 1.065226)),
                        Edge(point1: CLLocationCoordinate2D(latitude: 51.296675, longitude: 1.065226), point2: CLLocationCoordinate2D(latitude: 51.296497, longitude: 1.065427)), Edge(point1: CLLocationCoordinate2D(latitude: 51.296497, longitude: 1.065427), point2: CLLocationCoordinate2D(latitude: 51.296467, longitude: 1.065435)), Edge(point1: CLLocationCoordinate2D(latitude: 51.296467, longitude: 1.065435), point2: CLLocationCoordinate2D(latitude: 51.296451, longitude: 1.065422)), Edge(point1: CLLocationCoordinate2D(latitude: 51.296451, longitude: 1.065422), point2: (CLLocationCoordinate2D(latitude: 51.296389, longitude: 1.065267))), Edge(point1: CLLocationCoordinate2D(latitude: 51.296389, longitude: 1.065267), point2: (CLLocationCoordinate2D(latitude: 51.296409, longitude: 1.065220))), Edge(point1: CLLocationCoordinate2D(latitude: 51.296409, longitude: 1.065220), point2: CLLocationCoordinate2D(latitude: 51.296630, longitude: 1.064984)), Edge(point1: CLLocationCoordinate2D(latitude: 51.296630, longitude: 1.064984), point2: CLLocationCoordinate2D(latitude: 51.296701, longitude: 1.065161)),
                        Edge(point1: CLLocationCoordinate2D(latitude: 51.296701, longitude: 1.065161), point2: CLLocationCoordinate2D(latitude: 51.296694, longitude: 1.065198)), Edge(point1: CLLocationCoordinate2D(latitude: 51.296694, longitude: 1.065198), point2: CLLocationCoordinate2D(latitude:  51.296675, longitude: 1.065226))]
    
    // parking Spaces list of coordinates for each parking space
    
    static var parkingSpacesList
        = [
            //First space
            ParkingSpace(
                c1: CLLocationCoordinate2D(latitude: 51.29665, longitude: 1.065107)
                ,c2: CLLocationCoordinate2D(latitude: 51.296675, longitude: 1.065162)
                ,c3: CLLocationCoordinate2D(latitude: 51.296659, longitude: 1.065182)
                ,c4: CLLocationCoordinate2D(latitude: 51.296634, longitude: 1.065127)
            )
            //Second space
            ,ParkingSpace(
                c1: CLLocationCoordinate2D(latitude: 51.296658, longitude: 1.065181)
                ,c2: CLLocationCoordinate2D(latitude: 51.296635, longitude: 1.065126)
                ,c3: CLLocationCoordinate2D(latitude: 51.296616, longitude: 1.065144)
                ,c4: CLLocationCoordinate2D(latitude: 51.296641, longitude: 1.065202)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296616, longitude: 1.065147),
                c2: CLLocationCoordinate2D(latitude: 51.296641, longitude: 1.065204),
                c3: CLLocationCoordinate2D(latitude: 51.296623, longitude: 1.065223),
                c4: CLLocationCoordinate2D(latitude: 51.296598, longitude: 1.065167)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296598, longitude: 1.065167),
                c2: CLLocationCoordinate2D(latitude: 51.296623, longitude: 1.065223),
                c3: CLLocationCoordinate2D(latitude: 51.296605, longitude: 1.065242),
                c4: CLLocationCoordinate2D(latitude: 51.296580, longitude: 1.065186)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296605, longitude: 1.065242),
                c2: CLLocationCoordinate2D(latitude: 51.296580, longitude: 1.065186),
                c3: CLLocationCoordinate2D(latitude: 51.296563, longitude: 1.065207),
                c4: CLLocationCoordinate2D(latitude: 51.296588, longitude: 1.065262)
            ),
             ParkingSpace(
                c1: CLLocationCoordinate2D(latitude: 51.296563, longitude: 1.065207),
                c2: CLLocationCoordinate2D(latitude: 51.296588, longitude: 1.065262),
                c3: CLLocationCoordinate2D(latitude: 51.296569, longitude: 1.065284),
                c4: CLLocationCoordinate2D(latitude: 51.296545, longitude: 1.065225)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296569, longitude: 1.065284),
                c2: CLLocationCoordinate2D(latitude: 51.296545, longitude: 1.065225),
                c3: CLLocationCoordinate2D(latitude: 51.296528, longitude: 1.065247),
                c4: CLLocationCoordinate2D(latitude: 51.296553, longitude: 1.065302)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296528, longitude: 1.065247),
                c2: CLLocationCoordinate2D(latitude: 51.296553, longitude: 1.065302),
                c3: CLLocationCoordinate2D(latitude: 51.296535, longitude: 1.065323),
                c4: CLLocationCoordinate2D(latitude: 51.296510, longitude: 1.065266)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296535, longitude: 1.065323),
                c2: CLLocationCoordinate2D(latitude: 51.296510, longitude: 1.065266),
                c3: CLLocationCoordinate2D(latitude: 51.296493, longitude: 1.065286),
                c4: CLLocationCoordinate2D(latitude: 51.296517, longitude: 1.065342)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296493, longitude: 1.065286),
                c2: CLLocationCoordinate2D(latitude: 51.296517, longitude: 1.065342),
                c3: CLLocationCoordinate2D(latitude: 51.296500, longitude: 1.065360),
                c4: CLLocationCoordinate2D(latitude: 51.296475, longitude: 1.065305)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296500, longitude: 1.065360),
                c2: CLLocationCoordinate2D(latitude: 51.296475, longitude: 1.065305),
                c3: CLLocationCoordinate2D(latitude: 51.296458, longitude: 1.065325),
                c4: CLLocationCoordinate2D(latitude: 51.296482, longitude: 1.065380)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296458, longitude: 1.065325),
                c2: CLLocationCoordinate2D(latitude: 51.296482, longitude: 1.065380),
                c3: CLLocationCoordinate2D(latitude: 51.296465, longitude: 1.065402),
                c4: CLLocationCoordinate2D(latitude: 51.296441, longitude: 1.065345)
            ),
             ParkingSpace(
                c1: CLLocationCoordinate2D(latitude: 51.296441, longitude: 1.065345),
                c2: CLLocationCoordinate2D(latitude: 51.296416, longitude: 1.065291),
                c3: CLLocationCoordinate2D(latitude: 51.296433, longitude: 1.065271),
                c4: CLLocationCoordinate2D(latitude: 51.296457, longitude: 1.065325)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296433, longitude: 1.065271),
                c2: CLLocationCoordinate2D(latitude: 51.296457, longitude: 1.065325),
                c3: CLLocationCoordinate2D(latitude: 51.296476, longitude: 1.065307),
                c4: CLLocationCoordinate2D(latitude: 51.296450, longitude: 1.065252)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296476, longitude: 1.065307),
                c2: CLLocationCoordinate2D(latitude: 51.296450, longitude: 1.065252),
                c3: CLLocationCoordinate2D(latitude: 51.296469, longitude: 1.065230),
                c4: CLLocationCoordinate2D(latitude: 51.296491, longitude: 1.065286)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296469, longitude: 1.065230),
                c2: CLLocationCoordinate2D(latitude: 51.296491, longitude: 1.065286),
                c3: CLLocationCoordinate2D(latitude: 51.296511, longitude: 1.065266),
                c4: CLLocationCoordinate2D(latitude: 51.296486, longitude: 1.065210)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296511, longitude: 1.065266),
                c2: CLLocationCoordinate2D(latitude: 51.296486, longitude: 1.065210),
                c3: CLLocationCoordinate2D(latitude: 51.296503, longitude: 1.065191),
                c4: CLLocationCoordinate2D(latitude: 51.296528, longitude: 1.065247)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296503, longitude: 1.065191),
                c2: CLLocationCoordinate2D(latitude: 51.296528, longitude: 1.065247),
                c3: CLLocationCoordinate2D(latitude: 51.296545, longitude: 1.065227),
                c4: CLLocationCoordinate2D(latitude: 51.296523, longitude: 1.065171)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296545, longitude: 1.065227),
                c2: CLLocationCoordinate2D(latitude: 51.296523, longitude: 1.065171),
                c3: CLLocationCoordinate2D(latitude: 51.296538, longitude: 1.065153),
                c4: CLLocationCoordinate2D(latitude: 51.296563, longitude: 1.065209)
            ),
             ParkingSpace(
                c1: CLLocationCoordinate2D(latitude: 51.296538, longitude: 1.065153),
                c2: CLLocationCoordinate2D(latitude: 51.296563, longitude: 1.065209),
                c3: CLLocationCoordinate2D(latitude: 51.296580, longitude: 1.065185),
                c4: CLLocationCoordinate2D(latitude: 51.296556, longitude: 1.065133)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296580, longitude: 1.065185),
                c2: CLLocationCoordinate2D(latitude: 51.296556, longitude: 1.065133),
                c3: CLLocationCoordinate2D(latitude: 51.296574, longitude: 1.065110),
                c4: CLLocationCoordinate2D(latitude: 51.296597, longitude: 1.065167)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296574, longitude: 1.065110),
                c2: CLLocationCoordinate2D(latitude: 51.296597, longitude: 1.065167),
                c3: CLLocationCoordinate2D(latitude: 51.296615, longitude: 1.065146),
                c4: CLLocationCoordinate2D(latitude: 51.296591, longitude: 1.065091)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296615, longitude: 1.065146),
                c2: CLLocationCoordinate2D(latitude: 51.296591, longitude: 1.065091),
                c3: CLLocationCoordinate2D(latitude: 51.296609, longitude: 1.065071),
                c4: CLLocationCoordinate2D(latitude: 51.296633, longitude: 1.065127)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296609, longitude: 1.065071),
                c2: CLLocationCoordinate2D(latitude: 51.296633, longitude: 1.065127),
                c3: CLLocationCoordinate2D(latitude: 51.296650, longitude: 1.065107),
                c4: CLLocationCoordinate2D(latitude: 51.296626, longitude: 1.065051)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296638, longitude: 1.064919),
                c2: CLLocationCoordinate2D(latitude: 51.296625, longitude: 1.064891),
                c3: CLLocationCoordinate2D(latitude: 51.296575, longitude: 1.064945),
                c4: CLLocationCoordinate2D(latitude: 51.296589, longitude: 1.064973)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296575, longitude: 1.064945),
                c2: CLLocationCoordinate2D(latitude: 51.296589, longitude: 1.064973),
                c3: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025),
                c4: CLLocationCoordinate2D(latitude: 51.296531, longitude: 1.064996)
            ),
             ParkingSpace(
                c1: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025),
                c2: CLLocationCoordinate2D(latitude: 51.296531, longitude: 1.064996),
                c3: CLLocationCoordinate2D(latitude: 51.296478, longitude: 1.065052),
                c4: CLLocationCoordinate2D(latitude: 51.296495, longitude: 1.065078)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296478, longitude: 1.065052),
                c2: CLLocationCoordinate2D(latitude: 51.296495, longitude: 1.065078),
                c3: CLLocationCoordinate2D(latitude: 51.296452, longitude: 1.065130),
                c4: CLLocationCoordinate2D(latitude: 51.296438, longitude: 1.065100)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296452, longitude: 1.065130),
                c2: CLLocationCoordinate2D(latitude: 51.296438, longitude: 1.065100),
                c3: CLLocationCoordinate2D(latitude: 51.296391, longitude: 1.065152),
                c4: CLLocationCoordinate2D(latitude: 51.296404, longitude: 1.065183)
            ),
             ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296391, longitude: 1.065152),
                c2: CLLocationCoordinate2D(latitude: 51.296404, longitude: 1.065183),
                c3: CLLocationCoordinate2D(latitude: 51.296356, longitude: 1.065238),
                c4: CLLocationCoordinate2D(latitude: 51.296340, longitude: 1.065210)
            ),//here,
            ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296687, longitude: 1.065354),
                c2: CLLocationCoordinate2D(latitude: 51.296661, longitude: 1.065299),
                c3: CLLocationCoordinate2D(latitude: 51.296642, longitude: 1.065318),
                c4: CLLocationCoordinate2D(latitude: 51.296666, longitude: 1.065375)
            ),
            ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296642, longitude: 1.065318),
                c2: CLLocationCoordinate2D(latitude: 51.296666, longitude: 1.065375),
                c3: CLLocationCoordinate2D(latitude: 51.296648, longitude: 1.065399),
                c4: CLLocationCoordinate2D(latitude: 51.296624, longitude: 1.065341)
            ),
            ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296648, longitude: 1.065399),
                c2: CLLocationCoordinate2D(latitude: 51.296624, longitude: 1.065341),
                c3: CLLocationCoordinate2D(latitude: 51.296604, longitude: 1.065361),
                c4: CLLocationCoordinate2D(latitude: 51.296627, longitude: 1.065419)
            ),
            ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296604, longitude: 1.065361),
                c2: CLLocationCoordinate2D(latitude: 51.296627, longitude: 1.065419),
                c3: CLLocationCoordinate2D(latitude: 51.296611, longitude: 1.065440),
                c4: CLLocationCoordinate2D(latitude: 51.296584, longitude: 1.065384)
            ),
            ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296611, longitude: 1.065440),
                c2: CLLocationCoordinate2D(latitude: 51.296584, longitude: 1.065384),
                c3: CLLocationCoordinate2D(latitude: 51.296566, longitude: 1.065406),
                c4: CLLocationCoordinate2D(latitude: 51.296593, longitude: 1.065461)
            ),
            ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296566, longitude: 1.065406),
                c2: CLLocationCoordinate2D(latitude: 51.296593, longitude: 1.065461),
                c3: CLLocationCoordinate2D(latitude: 51.296572, longitude: 1.065486),
                c4: CLLocationCoordinate2D(latitude: 51.296547, longitude: 1.065427)
            ),
            ParkingSpace(
                c1: CLLocationCoordinate2D(latitude: 51.296572, longitude: 1.065486),
                c2: CLLocationCoordinate2D(latitude: 51.296547, longitude: 1.065427),
                c3: CLLocationCoordinate2D(latitude: 51.296528, longitude: 1.065448),
                c4: CLLocationCoordinate2D(latitude: 51.296553, longitude: 1.065503)
            ),
            ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296528, longitude: 1.065448),
                c2: CLLocationCoordinate2D(latitude: 51.296553, longitude: 1.065503),
                c3: CLLocationCoordinate2D(latitude: 51.296533, longitude: 1.065524),
                c4: CLLocationCoordinate2D(latitude: 51.296509, longitude: 1.065469)
            ),
            ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296533, longitude: 1.065524),
                c2: CLLocationCoordinate2D(latitude: 51.296509, longitude: 1.065469),
                c3: CLLocationCoordinate2D(latitude: 51.296491, longitude: 1.065492),
                c4: CLLocationCoordinate2D(latitude: 51.296515, longitude: 1.065546)
            ),
            ParkingSpace (
                c1: CLLocationCoordinate2D(latitude: 51.296491, longitude: 1.065492),
                c2: CLLocationCoordinate2D(latitude: 51.296515, longitude: 1.065546),
                c3: CLLocationCoordinate2D(latitude: 51.296497, longitude: 1.065563),
                c4: CLLocationCoordinate2D(latitude: 51.296472, longitude: 1.065513)
            )
    ]
    
    
    //route lines and free parking space coordinates
    
    static var route = [
        Route(edge1: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025),
              edge2: CLLocationCoordinate2D(latitude: 51.296531, longitude: 1.064996),
              edge3: CLLocationCoordinate2D(latitude: 51.296478, longitude: 1.065052),
              edge4: CLLocationCoordinate2D(latitude: 51.296495, longitude: 1.065078),
              edge5: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025)
        ),
        Route(edge1: CLLocationCoordinate2D(latitude: 51.296597, longitude: 1.065309),
              edge2: CLLocationCoordinate2D(latitude: 51.296470, longitude: 1.065455),
              edge3: CLLocationCoordinate2D(latitude: 51.296386, longitude: 1.065269),
              edge4: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
              edge5: CLLocationCoordinate2D(latitude: 51.296519, longitude: 1.065053)
        )
    ]
}
