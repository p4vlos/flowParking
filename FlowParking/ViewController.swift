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
    
    let parkingSpaces = ParkingSpace.getParkingSpaces()
    
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
        
        addPolygon()
        
    }
    
    //Draw on tha map
    func addPolygon() {
        mapView?.delegate = self
        var locations = parkingSpaces.map { $0.coordinate }
        let polygon = MKPolygon(coordinates: &locations, count: locations.count)
        mapView?.add(polygon)
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
