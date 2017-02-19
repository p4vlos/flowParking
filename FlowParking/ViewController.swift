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

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var minorLbl: UILabel!
    @IBOutlet weak var rssiLbl: UILabel!
    @IBOutlet weak var accuracyLbl: UILabel!
    @IBAction func share(_ sender: UIButton) {
        
        let sheet = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil)
        self.present(sheet, animated: true, completion: nil)
    }
    
    var message: String = ""
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        view.backgroundColor = UIColor.gray
        print("did load")
        
        
        
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
        
        
        if beacons.count > 0 {
            for i in 0..<beacons.count{
                message += "---- Time: \(time) Beacon(\(i)) Minor: \(beacons[i].minor) RSSI: \(beacons[i].rssi) Accuracy: \(beacons[i].accuracy) "
                updateDistance(beacons[i].proximity)
                
                print("found more than one beacon")
                //minor: 4608
                print(beacons[i].minor)
                //printing all info for the beacon
                self.minorLbl.text = "\(beacons[i].minor)"
                self.accuracyLbl.text = "\(beacons[i].accuracy)"
                self.rssiLbl.text = "\(beacons[i].rssi)"
            }
        } else {
            
            
            print("no beacons")
            
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
                self.view.backgroundColor = UIColor.gray
                self.distanceLbl.text = "UNKNOWN"
                print("distance Unknown")
                self.message += "Distance: unknown \n"
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceLbl.text = "FAR"
                print("distance Far")
                self.message += "Distance: far \n"
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceLbl.text = "NEAR"
                print("distance Near")
                self.message += "Distance: near \n"
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceLbl.text = "IMMEDIATE"
                print("distance Immediate")
                self.message += "Distance: immediate \n"
            }
        }
    }
}

