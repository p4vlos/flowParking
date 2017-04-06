//
//  data.swift
//  FlowParking
//
//  Created by Diana Karina Vainberg Gauna on 19/03/2017.
//  Copyright © 2017 Diana Karina Vainberg Gauna. All rights reserved.
//

import UIKit


class Data {
    
    var beaconA: [Double]
    var beaconB: [Double]
    var beaconC: [Double]
    var distA: Double
    var distB: Double
    var distC: Double
    
    init(beaconA: [Double], beaconB: [Double], beaconC: [Double], distA: Double, distB: Double, distC: Double){
        self.beaconA = beaconA
        self.beaconB = beaconB
        self.beaconC = beaconC
        self.distA = distA
        self.distB = distB
        self.distC = distC
        
    }
    
    func trilateration() -> (Double, Double) {
        
        let PI = 3.1415926535897932384626433832795028841971693993751
        let RADIANS = PI/180
        
        func norm (vector: [Double]) -> Double {
            return sqrt(vector.map{$0 * $0}.reduce(0, +))
        }
        
        func dot (vector1: [Double], vector2: [Double]) ->Double{
            return zip(vector1, vector2).map{$0 * $1}.reduce(0, +)
        }
        
        func cross (vector1 : [Double], vector2: [Double]) -> [Double] {
            let uvi = vector1[1] * vector2[2] - vector2[1] * vector1[2]
            let uvj = vector2[0] * vector1[2] - vector1[0] * vector2[2]
            let uvk = vector1[0] * vector2[1] - vector2[0] * vector1[1]
            let aux = [uvi, uvj, uvk]
            return aux
        }
        
        func add (vector1: [Double], vector2: [Double]) -> [Double]{
            return zip(vector1, vector2).map{$0 + $1}
        }
        func substract (vector1: [Double], vector2: [Double]) -> [Double]{
            return zip(vector1, vector2).map{$0 - $1}
        }
        
        func divide (vector: [Double], number: Double) -> [Double]{
            return vector.map{$0 / number}
        }
        
        func multiply (vector: [Double], number: Double) -> [Double]{
            return vector.map{$0 * number}
        }
        
        
        let earthR = 6371.00
        
        
        
            
            let LatA = beaconA[0]
            let LonA = beaconA[1]
            let DistA = distA/1000
            let LatB = beaconB[0]
            let LonB = beaconB[1]
            let DistB = distB/1000
            let LatC = beaconC[0]
            let LonC = beaconC[1]
            let DistC = distC/1000
            
        
        
            //#using authalic sphere
            //#if using an ellipsoid this step is slightly different
            //    #Convert geodetic Lat/Long to ECEF xyz
            //    #   1. Convert Lat/Long to radians
            //    #   2. Convert Lat/Long(radians) to ECEF
            let xA = (earthR * (cos(RADIANS * LatA) * cos(RADIANS * LonA)))
            let yA = (earthR * (cos(RADIANS * LatA) * sin(RADIANS * LonA)))
            let zA = (earthR * (sin(RADIANS * LatA)))
        
        
            let xB = (earthR * (cos(RADIANS * LatB) * cos(RADIANS * LonB)))
            let yB = (earthR * (cos(RADIANS * LatB) * sin(RADIANS * LonB)))
            let zB = (earthR * (sin(RADIANS * LatB)))
            
            
            let xC = (earthR * (cos(RADIANS * LatC) * cos(RADIANS * LonC)))
            let yC = (earthR * (cos(RADIANS * LatC) * sin(RADIANS * LonC)))
            let zC = (earthR * (sin(RADIANS * LatC)))
            
            
            let P1 = [xA, yA, zA]
            let P2 = [xB, yB, zB]
            let P3 = [xC, yC, zC]
            
            
            //from wikipedia
            //transform to get circle 1 at origin
            //transform to get circle 2 on x axis
            
            let sub21 = substract(vector1: P2, vector2: P1)
            let sub31 = substract(vector1: P3, vector2: P1)
            
            let ex = divide(vector: sub21, number: norm(vector: sub21))
            let i = dot(vector1: ex, vector2: sub31)
            let iex = ex.map{$0 * i}
            let subC = substract(vector1: sub31, vector2: iex)
            let ey = divide(vector: subC, number: norm(vector: subC))
            let ez = cross(vector1: ex, vector2: ey)
            let d = norm(vector: sub21)
            let j = dot(vector1: ey, vector2: sub31)
            
            //    #from wikipedia
            //    #plug and chug using above values
            
    
            
            let x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
            let y = ((pow(DistA,2) - pow(DistC,2) + pow(i,2) + pow(j,2))/(2*j)) - ((i/j)*x)
            
        
            //    # only one case shown here
            let z = sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
            
            //    #triPt is an array with ECEF x,y,z of trilateration point
            
            let addAux = add(vector1: P1, vector2: (multiply(vector: ex, number: x)))
        
            let addAux2 = add(vector1: (multiply(vector: ey, number: y)), vector2: (multiply(vector: ez, number: z)))
        
            var triPt = add(vector1: addAux, vector2: addAux2)
            
            //
            //    #convert back to lat/long from ECEF
            //    #convert to degrees
            let lat = (asin(triPt[2] / earthR))*180/PI
            let lon = (atan2(triPt[1],triPt[0]))*180/PI
            //
            print (lat, lon)
        

        return (lat,lon)
    }
    
    func trilaterationInMeters() -> (Double, Double) {
        
        let W: Double
        let Z: Double
        let x: Double
        var y: Double
        let y2: Double
        let xA = beaconA[0]
        let yA = beaconA[1]
        let xB = beaconB[0]
        let yB = beaconB[1]
        let xC = beaconC[0]
        let yC = beaconC[1]
        
        
        
        //Z, x, y, y2;
        W = distA*distA - distB*distB - Double(xA*xA) - Double(yA*yA) + Double(xB*xB) + Double(yB*yB)
        Z = distB*distB - distC*distC - Double(xB*xB) - Double(yB*yB) + Double(xC*xC) + Double(yC*yC);
        
        x = (W*(Double(yC - yB)) - Z*(Double(yB - yA))) / Double(2*((xB-xA)*(yC-yB) - (xC-xB)*(yB-yA)));
        y = (W - (2*x*Double(xB-xA))) / (Double(2*(yB-yA)));
        //y2 is a second measure of y to mitigate errors
        y2 = (Z - 2*x*Double(xC-xB)) / (Double(2*(yC-yB)));
        
        y = (y + y2) / 2;
        
        return (x,y)
        
    }

}
