//: Playground - noun: a place where people can play
import UIKit

//#assuming elevation = 0
let PI = 3.1415926535897932384626433832795028841971693993751
let RADIANS = PI/180


let earthR = 6371.00
let LatA = 37.418436
let LonA = -121.963477
let DistA = 0.265710701754
let LatB = 37.417243
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

func substract (vector1: [Double], vector2: [Double]) -> [Double]{
    return zip(vector1, vector2).map{$0 - $1}
}

func divide (vector: [Double], number: Double) -> [Double]{
    return vector.map{$0 / number}
}

func multiply (vector: [Double], number: Double) -> [Double]{
    return vector.map{$0 * number}
}

//from wikipedia
//transform to get circle 1 at origin
//transform to get circle 2 on x axis
//<<<<<<< Updated upstream
//=======
//
//var sub21 = zip(P2, P1).map{$0.0 - $0.1}
//
//
//// To divde 2 vectors do this
//let vector1 = [1,2,3,4]
//let vector2 = [2,3,4,5]
//var vectorDivision = zip(vector1, vector2).map { $0 / $1 }
//print(vectorDivision)
//
//>>>>>>> Stashed changes

var sub21 = substract(vector1: P2, vector2: P1)
var sub31 = substract(vector1: P3, vector2: P1)

var ex = divide(vector: sub21, number: norm(vector: sub21))
var i = dot(vector1: ex, vector2: sub31)
var iex = ex.map{$0 * i}
var subC = substract(vector1: sub31, vector2: iex)
var ey = divide(vector: subC, number: norm(vector: subC))
var ez = cross(vector1: ex, vector2: ey)
var d = norm(vector: sub21)
var j = dot(vector1: ey, vector2: sub31)

//    #from wikipedia
//    #plug and chug using above values


let x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
let y = ((pow(DistA,2) - pow(DistC,2) + pow(i,2) + pow(j,2))/(2*j)) - ((i/j)*x)

//    # only one case shown here
let z = sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
//
//    #triPt is an array with ECEF x,y,z of trilateration point
let triPt = P1 + multiply(vector: ex, number: x) + multiply(vector: ey, number: y) + multiply(vector: ez, number: z)
//
//    #convert back to lat/long from ECEF
//    #convert to degrees
let lat = (asin(triPt[2] / earthR))*180/PI
let lon = (atan2(triPt[1],triPt[0]))*180/PI
//
print (lat, lon)
