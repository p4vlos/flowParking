//: Playground - noun: a place where people can play
import UIKit

//#assuming elevation = 0
let PI = 3.1415926535897932384626433832795028841971693993751
let RADIANS = PI/180

let beacon1 = [51.296624, 1.064893]
let beacon2 = [51.296529, 1.064997]
let beacon3 = [51.296441, 1.065092]
let beacon4 = [51.296356, 1.065246]
let beacon5 = [51.296692, 1.065065]
let beacon6 = [51.296634, 1.065126]
let beacon7 = [51.296548, 1.065225]
let beacon8 = [51.296458, 1.065325]
let beacon9 = [51.296409, 1.065383]
let beacon10 = [51.296761, 1.065229]
let beacon11 = [51.296685, 1.065357]
let beacon12 = [51.296592, 1.065457]
let beacon13 = [51.296497, 1.065561]

//Python example
//let beaconA = [37.418436, -121.963477]
//let beaconB = [37.417243, -121.961889]
//let beaconC = [37.418692, -121.960194]





class data {
    
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
}
var exp0 = data(beaconA: beacon13, beaconB: beacon9, beaconC: beacon12, distA: 10.0/1000, distB: 10.2881728179016/1000, distC: 12.9154966501488/1000)
var exp1 = data(beaconA: beacon9, beaconB: beacon13, beaconC: beacon12, distA: 10.5153551314495/1000, distB: 11.2193048912653/1000, distC: 12.9154967493579/1000)
var exp2 = data(beaconA: beacon12, beaconB: beacon9, beaconC: beacon13, distA: 10.4816766826863/1000, distB: 11.1363200558594/1000, distC: 12.2279276116553/1000)

var exp3 = data(beaconA: beacon13, beaconB: beacon9, beaconC: beacon8, distA: 8.34807228213284/1000, distB: 8.89204648383791/1000, distC: 10.0/1000)

var exp4 = data(beaconA: beacon9, beaconB: beacon4, beaconC: beacon13, distA: 3.16900014429914/1000 , distB:  6.52823809149675/1000, distC: 16.6810054382124/1000)
var exp5 = data(beaconA: beacon3, beaconB: beacon2, beaconC: beacon7, distA: 5.05463879495952/1000, distB: 13.1271327170505/1000 , distC: 14.6779926762207/1000)
var exp6 = data(beaconA: beacon3, beaconB: beacon2, beaconC: beacon7, distA:  4.70156595444552/1000 , distB: 12.0179346365065/1000 , distC: 13.9088643434738/1000)
var exp7 = data(beaconA: beacon3, beaconB: beacon2, beaconC: beacon7, distA: 5.93676101499252/1000, distB: 8.19455666415653/1000, distC: 13.9983204893434/1000)
var exp8 = data(beaconA: beacon2 , beaconB: beacon3, beaconC: beacon5, distA: 7.74456526537434/1000, distB: 8.65774424211706/1000, distC: 16.6810054382124/1000)

//Python example
//var exp9 = data(beaconA: beaconA, beaconB: beaconB, beaconC: beaconC, distA: 0.265710701754, distB: 0.234592423446, distC: 0.0548954278262)
//var exp10 = data(beaconA: beaconA, beaconB: beaconB, beaconC: beaconC, distA: 0.265710701754, distB: 0.234592423446, distC: 0.0548954278262)

var exp9 = data(beaconA: beacon1, beaconB: beacon2, beaconC: beacon6, distA: 7.8711711795281/1000, distB: 11.870836583525/1000, distC: 14.6779927621778/1000)


var expList = [exp0, exp1, exp2, exp3, exp4, exp5, exp6, exp7, exp8, exp9]

func trilateration (listExp: [data]) -> [(Double, Double)] {
    
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
    var allPositions = [(Double, Double)]()
    
    for exp in listExp {
        
        let LatA = exp.beaconA[0]
        let LonA = exp.beaconA[1]
        let DistA = exp.distA
        let LatB = exp.beaconB[0]
        let LonB = exp.beaconB[1]
        let DistB = exp.distB
        let LatC = exp.beaconC[0]
        let LonC = exp.beaconC[1]
        let DistC = exp.distC
        
        //let LatA = 51.296761//37.418436
        //let LonA = 1.065229//-121.963477
        //let DistA = 12.7821416673243//0.265710701754
        //let LatB = 51.296685//37.417243
        //let LonB = 1.065357 //-121.961889
        //let DistB = 14.6779926762207//0.234592423446
        //let LatC = 51.296761//37.418692
        //let LonC = 1.065229//-121.960194
        //let DistC =  12.8570178450369 //0.0548954278262
        
        //#using authalic sphere
        //#if using an ellipsoid this step is slightly different
        //    #Convert geodetic Lat/Long to ECEF xyz
        //    #   1. Convert Lat/Long to radians
        //    #   2. Convert Lat/Long(radians) to ECEF
        let xA = (earthR * (cos(RADIANS * LatA) * cos(RADIANS * LonA)))
        let yA = (earthR * (cos(RADIANS * LatA) * sin(RADIANS * LonA)))
        let zA = (earthR * (sin(RADIANS * LatA)))
        
        print("-------------- ")
        
//        print("xA \(xA) \n")
//        print("yA \(yA) \n")
//        print("zA \(zA) \n")
        
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
        
        //print("d \(d) \n")
        
        let x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
        let y = ((pow(DistA,2) - pow(DistC,2) + pow(i,2) + pow(j,2))/(2*j)) - ((i/j)*x)
        
//        print("x \(x) \n")
//        print("y \(y) \n")
        
        //    # only one case shown here
        let z = sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
        
        
//        print("pow(DistA,2), pow(x,2) , pow(y,2) \(pow(DistA,2), pow(x,2), pow(y,2)) \n")
//        print("z \(z) \n")
        //
        //    #triPt is an array with ECEF x,y,z of trilateration point

        let addAux = add(vector1: P1, vector2: (multiply(vector: ex, number: x)))
        //print("addAux \(addAux) \n")
        let addAux2 = add(vector1: (multiply(vector: ey, number: y)), vector2: (multiply(vector: ez, number: z)))
        //print("addAux2 \(addAux2) \n")
        var triPt = add(vector1: addAux, vector2: addAux2)
        
        //
        //    #convert back to lat/long from ECEF
        //    #convert to degrees
        let lat = (asin(triPt[2] / earthR))*180/PI
        let lon = (atan2(triPt[1],triPt[0]))*180/PI
        //
        print (lat, lon)
        allPositions.append(lat,lon)
    }
    
    return allPositions
}

var results = trilateration(listExp: expList)



