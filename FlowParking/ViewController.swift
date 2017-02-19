//
//  ViewController.swift
//  FlowParking
//
//  Created by Pavlos Nicolaou on 20/01/2017.
//  Copyright © 2017 Pavlos Nicolaou. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var rawDistanceLbl: UILabel!
    @IBOutlet weak var accuracyLbl: UILabel!
    
    var locationManager: CLLocationManager!
    var report = ""
    
    //UIDocument variables
    var document: MyDocument?
    var documentURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        view.backgroundColor = UIColor.gray
        print("did load")
        
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        documentURL = dirPaths[0].appendingPathComponent("Savefile.txt")
        
        document = MyDocument(fileURL: documentURL!)
        document!.userText = "this is what we need to save"
        
        if filemgr.fileExists(atPath: (documentURL?.path)!) {
            
            document?.open(completionHandler: {(success: Bool) -> Void in
                if success {
                    print("File open OK")
                    //print(self.document?.userText)
                } else {
                    print("Failed to open file")
                }
            })
        } else {
            document?.save(to: documentURL!, for: .forCreating,
                           completionHandler: {(success: Bool) -> Void in
                            if success {
                                print("File created OK")
                            } else {
                                print("Failed to create file ")
                            }
            })
        }

        
       // saveDocument()
        
        
        
    }

    func saveDocument() {
        document!.userText = "Here is the saved document"
        
        document?.save(to: documentURL!,
                       for: .forOverwriting,
                       completionHandler: {(success: Bool) -> Void in
                        if success {
                            print("File overwrite OK")
                        } else {
                            print("File overwrite failed")
                        }
        })
        
    }
    
    //Share button Outlet
    @IBAction func shareButtonClicked(_ sender: Any) {
        let message = report
        
        let sheet = UIActivityViewController(
            activityItems: [message],
            applicationActivities: nil)
        self.present(sheet, animated: true, completion: nil)
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
        //let uuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
        //let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        //locationManager.startMonitoring(for: beaconRegion)
        //locationManager.startRangingBeacons(in: beaconRegion)
        
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
        
        if beacons.count > 0 {
            self.rawDistanceLbl.text = "\(beacons[0].rssi)"
            updateDistance(beacons[0].proximity)
            print("found more than one beacon")
            
            report.append("0: RSSI of \(beacons[0].minor) is ")
            report.append("\(beacons[0].rssi)\n")
            //timestamp
            report.append("1: RSSI of \(beacons[1].minor) is ")
            report.append("\(beacons[1].rssi)\n")
            //timestamp
            report.append("2: RSSI of \(beacons[2].minor) is ")
            report.append("\(beacons[2].rssi)\n")
            //timestamp
            report.append("3: RSSI of \(beacons[3].minor) is ")
            report.append("\(beacons[3].rssi)\n")
            //timestamp

            
            //minor: 4608
            //print(beacons[0].minor)
            //printing all info for the beacon
            self.accuracyLbl.text = "\(beacons[1].rssi)"
//            print("beacon 1 ")
//            print(beacons[0].rssi)
//            print("beacon 2 ")
//            print(beacons[1].rssi)
//            print("beacon 3 ")
//            print(beacons[2].rssi)
//            print("beacon 4 ")
//            print(beacons[3].rssi)
//            print("beacon 5 ")
//            print(beacons[4].rssi)
//            print("beacon 6")
//            print(beacons[5].rssi)
//            print("beacon 7 ")
//            print(beacons[6].rssi)
//            print("beacon 8 ")
//            print(beacons[7].rssi)
//            print("beacon 9 ")
//            print(beacons[8].rssi)
//            print("beacon 10 ")
//            print(beacons[9].rssi)
//            print("beacon 11 ")
//            print(beacons[10].rssi)
//            print("beacon 12 ")
//            print(beacons[11].rssi)
//            print("beacon 13")
//            print(beacons[12].rssi)
//            print("beacon 14 ")
//            print(beacons[13].rssi)

        } else {
            
        }
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.3) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceLbl.text = "UNKNOWN"
                print("distance Unknown")
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceLbl.text = "FAR"
                print("distance Far")
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceLbl.text = "NEAR"
                print("distance Near")
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceLbl.text = "IMMEDIATE"
                print("distance Immediate")
            }
        }
    }
}

