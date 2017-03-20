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

class ViewController: UIViewController, CLLocationManagerDelegate {


    @IBOutlet weak var mapView: MKMapView!
    
//    @IBOutlet weak var distanceLbl: UILabel!
//    @IBOutlet weak var minorLbl: UILabel!
//    @IBOutlet weak var rssiLbl: UILabel!
//    @IBOutlet weak var accuracyLbl: UILabel!
    @IBAction func share(_ sender: UIButton) {
        
        let sheet = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil)
        self.present(sheet, animated: true, completion: nil)
    }
    
    var message: String = ""
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        print("did load")
        
        let latitude = 51.296624
        let longitude = 1.064893
        
        
        mapView.mapType = .satellite
        
        let location = CLLocationCoordinate2D(
            latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print("status authorised")
            
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                print("is monitoring")
                if CLLocationManager.isRangingAvailable() {
                    print("scanning")
                    startScanning()
                }
            }
        }
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
                
                message += "---- Time: \(time) Beacon(\(i)) Minor: \(beacons[i].minor) RSSI: \(beacons[i].rssi) Accuracy: \(beacons[i].accuracy) "
                updateDistance(beacons[i].proximity)
                let minor = beacons[i].minor as Int
                if let lat = beaconsPos[minor]?[0]{
                    print("Latitude of beacon \(minor): \(lat)")
                }
                if let lon = beaconsPos[minor]?[1]{
                    print("Longitude of beacon \(minor): \(lon)")
                }
               
                if (beacons[i].rssi != 0){
                    switch triCount{
                        case 0:
                            minor1 = beacons[i].minor as Int
                            accuracy1 = beacons[i].accuracy as Double
                            triCount += 1
                        case 1:
                            minor2 = beacons[i].minor as Int
                            accuracy2 = beacons[i].accuracy as Double
                            triCount += 1
                        case 2:
                            let lat1 = beaconsPos[minor1]![0]
                            let lon1 = beaconsPos[minor1]![1]
                            
                            let lat2 = beaconsPos[minor2]![0]
                            let lon2 = beaconsPos[minor2]![1]
                            
                            let minor3 = beacons[i].minor as Int
                            let lat3 = beaconsPos[minor3]![0]
                            let lon3 = beaconsPos[minor3]![1]
                            
                            let data = Data(beaconA: [lat1, lon1], beaconB: [lat2, lon2], beaconC: [lat3, lon3], distA: accuracy1, distB: accuracy2, distC: beacons[i].accuracy)
                        
                            let result = data.trilateration()
                            print(result)
                            
                            
                            message += "Trilateration position: \(result) \n"
                            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
                            message += "CoreLoc position: \(locValue.latitude) \(locValue.longitude) \n"
                            
                            
                            // ------ MAP ------
           
                            // add mark
                            let point = MKPointAnnotation()
                            point.coordinate.latitude = result.0
                            point.coordinate.longitude = result.1
                            mapView.addAnnotation(point)
                            
                            
                            // ------ MAP ------
                            
                            triCount += 1
                        case 3:
                            minor1 = beacons[i].minor as Int
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
                self.message += "Distance: unknown \n"
            case .far:
                //self.view.backgroundColor = UIColor.blue
                //self.distanceLbl.text = "Proximity Far"
                print("distance Far")
                self.message += "Distance: far \n"
            case .near:
                //self.view.backgroundColor = UIColor.orange
                //self.distanceLbl.text = "Proximity Near"
                print("distance Near")
                self.message += "Distance: near \n"
            case .immediate:
                //self.view.backgroundColor = UIColor.red
                //self.distanceLbl.text = "Proximity Immediate"
                print("distance Immediate")
                self.message += "Distance: immediate \n"
            }
        }
    }
}

