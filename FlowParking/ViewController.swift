//
//  ViewController.swift
//  flowPark
//
//  Created by Diana Karina Vainberg Gauna on 16/02/2017.
//  Copyright © 2017 Diana Karina Vainberg Gauna. All rights reserved.
//

import UIKit
import CoreLocation
import Social
import MapKit
//, MKMapViewDelegate
class ViewController: UIViewController, CLLocationManagerDelegate {


    @IBOutlet weak var mapView: MKMapView!
    
    //let parkingSpaces = ParkingSpace.getParkingSpaces()
    
    var mapHasCenteredOnce = false
    
//    @IBOutlet weak var distanceLbl: UILabel!
//    @IBOutlet weak var minorLbl: UILabel!
//    @IBOutlet weak var rssiLbl: UILabel!
//    @IBOutlet weak var accuracyLbl: UILabel!
//    Previous share button
//    @IBAction func share(_ sender: UIButton) {
//        
//        let sheet = UIActivityViewController(
//            activityItems: [ViewController.message],
//            applicationActivities: nil)
//        self.present(sheet, animated: true, completion: nil)
//    }
    
    static var message: String = ""
    
    let latitude = 51.296624
    let longitude = 1.064893
    var locationManager: CLLocationManager!
    
    var beaconsPos: [Int: [Double]] = [42397: [51.296624, 1.064893],
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
    var parkingSpacesList
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
            ),//here,
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        // setting map view delegate with controller
        self.mapView.delegate = self

        print("did load")
        
        mapView.mapType = .satellite
        
       // let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpanMake(0.0015, 0.0015)
       // let region = MKCoordinateRegionMake(location, span)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
        mapView.setRegion(region, animated: true)
        
        addPolygons()
        
    }
    
    //Draw on tha map
    
    func addPolygons() {
        mapView?.delegate = self
        
        for space in parkingSpacesList {
            let polygon = MKPolygon(coordinates: &space.coordinates, count: 4)
            mapView?.add(polygon)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("status authorised")
            
            //Beacon's code
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                print("is monitoring")
//                if CLLocationManager.isRangingAvailable() {
//                    print("scanning")
//                    startScanning()
//                }
//            }
        }
    }
    

    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func startScanning() {
        print("start Scanning")
        
        if let uuid = NSUUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e") {
            let beaconRegion = CLBeaconRegion(proximityUUID: uuid as UUID, identifier: "MyBeacon")
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        }
        else {
            NSLog("Invalid UUID format")
        }
        
    }
    
    
    
    /* Beacon's code
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        //print(manager.desiredAccuracy)
    
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        let time = "\(hour):\(minutes):\(seconds)"
        print(time)
        let total = "Number of beacons: \(beacons.count)"
        print(total)
        
        var minor1 = 0
        var minor2  = 0
        var accuracy1 = 0.0
        var accuracy2 = 0.0
        
        var triCount = 0
        
        if beacons.count > 0 {
            
            print("Found more than one beacon")
            
            for i in 0..<beacons.count{
                
                ViewController.message += "---- Time: \(time) Beacon(\(i)) Minor: \(beacons[i].minor) RSSI: \(beacons[i].rssi) Accuracy: \(beacons[i].accuracy) "
                updateDistance(beacons[i].proximity)
                let minor = beacons[i].minor as! Int
                if let lat = beaconsPos[minor]?[0]{
                    print("Latitude of beacon \(minor): \(lat)")
                }
                if let lon = beaconsPos[minor]?[1]{
                    print("Longitude of beacon \(minor): \(lon)")
                }
               
                if (beacons[i].rssi != 0){
                    switch triCount{
                        case 0:
                            minor1 = beacons[i].minor as! Int
                            accuracy1 = beacons[i].accuracy as Double
                            triCount += 1
                        case 1:
                            minor2 = beacons[i].minor as! Int
                            accuracy2 = beacons[i].accuracy as Double
                            triCount += 1
                        case 2:
                            let lat1 = beaconsPos[minor1]![0]
                            let lon1 = beaconsPos[minor1]![1]
                            
                            let lat2 = beaconsPos[minor2]![0]
                            let lon2 = beaconsPos[minor2]![1]
                            
                            let minor3 = beacons[i].minor as! Int
                            let lat3 = beaconsPos[minor3]![0]
                            let lon3 = beaconsPos[minor3]![1]
                            
                            let data = Data(beaconA: [lat1, lon1], beaconB: [lat2, lon2], beaconC: [lat3, lon3], distA: accuracy1, distB: accuracy2, distC: beacons[i].accuracy)
                        
                            let result = data.trilateration()
                            print(result)
                            
                            
                            ViewController.message += "Trilateration position: \(result) \n"
                            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
                            ViewController.message += "CoreLoc position: \(locValue.latitude) \(locValue.longitude) \n"
                            
                            
                            // ------ MAP ------
           
                            // add mark
                            let point = MKPointAnnotation()
                            point.coordinate.latitude = result.0
                            point.coordinate.longitude = result.1
                            mapView.addAnnotation(point)
                            
                            
                            // ------ MAP ------
                            
                            triCount += 1
                        case 3:
                            minor1 = Int(beacons[i].minor)
                            accuracy1 = beacons[i].accuracy
                            triCount = 1
                        default:
                            print("Default case")
                    }
                }
               
                //printing all info for the beacon
//                self.minorLbl.text = "Beacon's Minor: \(beacons[0].minor)"
//                self.accuracyLbl.text = "Beacon's Accuracy: \(beacons[0].accuracy)"
//                self.rssiLbl.text = "Beacon's RSSI: \(beacons[0].rssi)"
                
                //var beaconA[0] = beacons[1].minor[0]
            }
            print("out of the for")
        } else {
            // No beacons around Alert
            // create the alert
            let alert = UIAlertController(title: "No beacons around", message: "Out of range", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.3) {
            switch distance {
            case .unknown:
                //self.view.backgroundColor = UIColor.gray
                //self.distanceLbl.text = "Proximity Unknonw"
                print("distance Unknown")
                ViewController.message += "Distance: unknown \n"
            case .far:
                //self.view.backgroundColor = UIColor.blue
                //self.distanceLbl.text = "Proximity Far"
                print("distance Far")
                ViewController.message += "Distance: far \n"
            case .near:
                //self.view.backgroundColor = UIColor.orange
                //self.distanceLbl.text = "Proximity Near"
                print("distance Near")
                ViewController.message += "Distance: near \n"
            case .immediate:
                //self.view.backgroundColor = UIColor.red
                //self.distanceLbl.text = "Proximity Immediate"
                print("distance Immediate")
                ViewController.message += "Distance: immediate \n"
            }
        }
    }
    
    */
}

private extension MKPolyline {
    convenience init(coordinates coords: Array<CLLocationCoordinate2D>) {
        let unsafeCoordinates = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: coords.count)
        unsafeCoordinates.initialize(from: coords)
        
        self.init(coordinates: unsafeCoordinates, count: coords.count)
        unsafeCoordinates.deallocate(capacity: coords.count)
    }
}

//MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "place icon")
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
            
        } else if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
            
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 2
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
       // guard let annotation = view.annotation as? Place, let title = annotation.title else { return }
        
       // let alertController = UIAlertController(title: "Welcome to \(title)", message: "You've selected \(title)", preferredStyle: .alert)
        //let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
       // alertController.addAction(cancelAction)
        //present(alertController, animated: true, completion: nil)
    }
}
