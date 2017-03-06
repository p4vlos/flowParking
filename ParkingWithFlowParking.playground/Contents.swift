//: Playground - noun: a place where people can play

import UIKit
import Darwin

//#assuming elevation = 0
let earthR = 6371
let LatA = CDouble(37.418436)
let LonA = CDouble(-121.963477)
let DistA = 0.265710701754
let LatB = (37.417243
let LonB = -121.961889
let DistB = 0.234592423446
let LatC = 37.418692
let LonC = -121.960194
let DistC = 0.0548954278262

//#using authalic sphere
//#if using an ellipsoid this step is slightly different
//    #Convert geodetic Lat/Long to ECEF xyz
//    #   1. Convert Lat/Long to radians
//    #   2. Convert Lat/Long(radians) to ECEF
    var xA = earthR * (cos(radians(LatA)) * cos(radians(LonA)))
    var yA = earthR * (cos(radians(LatA)) * sin(radians(LonA)))
    var zA = earthR * (sin(radians(LatA)))
    
    var xB = earthR * (cos(radians(LatB)) * cos(radians(LonB)))
    var yB = earthR * (cos(radians(LatB)) * sin(radians(LonB)))
    var zB = earthR * (sin(radians(LatB)))
    
    var xC = earthR * (cos(radians(LatC)) * cos(radians(LonC)))
    var yC = earthR * (cos(radians(LatC)) * sin(radians(LonC)))
    var zC = earthR * (sin(radians(LatC)))
    
    var P1 = numpy.array([xA, yA, zA])
    var P2 = numpy.array([xB, yB, zB])
    var P3 = numpy.array([xC, yC, zC])
    
    #from wikipedia
    #transform to get circle 1 at origin
    #transform to get circle 2 on x axis
    ex = (P2 - P1)/(numpy.linalg.norm(P2 - P1))
    i = numpy.dot(ex, P3 - P1)
    ey = (P3 - P1 - i*ex)/(numpy.linalg.norm(P3 - P1 - i*ex))
    ez = numpy.cross(ex,ey)
    d = numpy.linalg.norm(P2 - P1)
    j = numpy.dot(ey, P3 - P1)
    
    #from wikipedia
    #plug and chug using above values
    x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
    y = ((pow(DistA,2) - pow(DistC,2) + pow(i,2) + pow(j,2))/(2*j)) - ((i/j)*x)
    
    # only one case shown here
    z = numpy.sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
    
    #triPt is an array with ECEF x,y,z of trilateration point
    triPt = P1 + x*ex + y*ey + z*ez
    
    #convert back to lat/long from ECEF
    #convert to degrees
    lat = math.degrees(math.asin(triPt[2] / earthR))
    lon = math.degrees(math.atan2(triPt[1],triPt[0]))
    
    print lat, lon
