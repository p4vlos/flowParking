//: Playground - noun: a place where people can play

import UIKit
import Darwin

//#assuming elevation = 0
let PI = CDouble(3.1415926535897932384626433832795028841971693993751)
let RADIANS = CDouble(180.00/PI)


let earthR = CDouble(6371.00)
let LatA = CDouble(37.418436)
let LonA = CDouble(-121.963477)
let DistA = CDouble(0.265710701754)
let LatB = CDouble(37.417243)
let LonB = CDouble(-121.961889)
let DistB = CDouble(0.234592423446)
let LatC = CDouble(37.418692)
let LonC = CDouble(-121.960194)
let DistC = CDouble(0.0548954278262)

//#using authalic sphere
//#if using an ellipsoid this step is slightly different
//    #Convert geodetic Lat/Long to ECEF xyz
//    #   1. Convert Lat/Long to radians
//    #   2. Convert Lat/Long(radians) to ECEF
var xA = (earthR * (cos(RADIANS * LatA) * cos(RADIANS * LonA)))
var yA = (earthR * (cos(RADIANS * LatA) * sin(RADIANS * LonA)))
var zA = (earthR * (sin(RADIANS * LatA)))
    
var xB = (earthR * (cos(RADIANS * LatB) * cos(RADIANS * LonB)))
var yB = (earthR * (cos(RADIANS * LatB) * sin(RADIANS * LonB)))
var zB = (earthR * (sin(RADIANS * LatB)))
    
var xC = (earthR * (cos(RADIANS * LatC) * cos(RADIANS * LonC)))
var yC = (earthR * (cos(RADIANS * LatC) * sin(RADIANS * LonC)))
var zC = (earthR * (sin(RADIANS * LatC)))
    
var P1 = [xA, yA, zA]
var P2 = [xB, yB, zB]
var P3 = [xC, yC, zC]

//from wikipedia
//transform to get circle 1 at origin
//transform to get circle 2 on x axis
//var ex = (P2 - P1)


//    ex = (P2 - P1)/(numpy.linalg.norm(P2 - P1))
//    i = numpy.dot(ex, P3 - P1)
//    ey = (P3 - P1 - i*ex)/(numpy.linalg.norm(P3 - P1 - i*ex))
//    ez = numpy.cross(ex,ey)
//    d = numpy.linalg.norm(P2 - P1)
//    j = numpy.dot(ey, P3 - P1)
//    
//    #from wikipedia
//    #plug and chug using above values
//    x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
//    y = ((pow(DistA,2) - pow(DistC,2) + pow(i,2) + pow(j,2))/(2*j)) - ((i/j)*x)
//    
//    # only one case shown here
//    z = numpy.sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
//    
//    #triPt is an array with ECEF x,y,z of trilateration point
//    triPt = P1 + x*ex + y*ey + z*ez
//    
//    #convert back to lat/long from ECEF
//    #convert to degrees
//    lat = math.degrees(math.asin(triPt[2] / earthR))
//    lon = math.degrees(math.atan2(triPt[1],triPt[0]))
//    
//    print lat, lon
