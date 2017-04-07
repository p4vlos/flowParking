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
    
    
    var mapHasCenteredOnce = false
    
    static var message: String = ""
    
    let latitude = 51.296634
    let longitude = 1.065126
    var locationManager: CLLocationManager!
    //Position of one of the beacons
    var position = (0.0, 0.0)
    var deletePolyline = false
    var polylineAux = MKPolyline()
    var closestEdgeLat = 0.0
    
    
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
    
    // MARK: - Draw on tha map
    
    func addPolygons() {
        mapView?.delegate = self
        
        for space in Position.parkingSpacesList {
            let polygon = MKPolygon(coordinates: &space.coordinates, count: 4)
            
            mapView?.add(polygon)
        }
    }
    
    // MARK: - Draw route line
    
    func addPolyline() {
        mapView?.delegate = self
        
        for line in Position.route {
            let polyline = MKPolyline(coordinates: &line.coordinates, count: 5)
            if deletePolyline == true{
                mapView?.remove(polylineAux)
                deletePolyline = false
            }
            mapView?.add(polyline)
            polylineAux = polyline
            
        }
        deletePolyline = true
    }
    
    // Returns projection point and distance
    func projectNodeToEdge(point: CLLocationCoordinate2D) -> (CLLocationCoordinate2D, Edge) {
        
        var dist = -1.0
        var proj = CLLocationCoordinate2D()
        var closestEdge = Edge(point1: CLLocationCoordinate2D(), point2: CLLocationCoordinate2D())
        
        for edge in Position.edges {
            
            let apx = point.latitude - edge.point1.latitude
            let apy = point.longitude - edge.point1.longitude
            let abx = edge.point2.latitude - edge.point1.latitude
            let aby = edge.point2.longitude - edge.point1.longitude
            
            let ab2 = abx * abx + aby * aby
            let ap_ab = apx * abx + apy * aby
            var t = ap_ab / ab2
            // Clamp to segment
            if (t < 0) {
                t = 0
            } else if (t > 1) {
                t = 1
            }
            let p = CLLocationCoordinate2D(latitude: edge.point1.latitude + abx * t, longitude: edge.point1.longitude + aby * t)
            let d = distance(pA: point, pB: p)
            
            if dist == -1.0{
                dist = d
                proj = p
                closestEdge = edge
            }
            if d < dist {
                dist = d
                proj = p
                closestEdge = edge
                
            }
            
        }
        return (proj, closestEdge)
        
    }
    //Returns distance from a point to an edge
    func distance(pA: CLLocationCoordinate2D, pB: CLLocationCoordinate2D) -> Double {
        let dx = pA.latitude - pB.latitude
        let dy = pA.longitude - pB.longitude
        let distance = sqrt(dx * dx + dy * dy)
        return distance
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            print("status authorised")
            
            //Beacon's code
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                print("is monitoring")
                if CLLocationManager.isRangingAvailable() {
                    print("scanning")
                    startScanning()
                }
            }
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
    
    
    
    //Beacon's code
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        let time = "\(hour):\(minutes):\(seconds)"
        print(time)
        let total = "Number of beacons: \(beacons.count)"
        print(total)
        
        var posx1 = 0.0
        var posy1 = 0.0
        var posx2 = 0.0
        var posy2 = 0.0
        var posx3 = 0.0
        var posy3 = 0.0
        
        
        if beacons.count > 0 {
            
            print("Found at least one beacon")
            
            let usefulBeacons = beacons.filter{$0.rssi != 0}
            
            
            if usefulBeacons.count >= 3 {
                for i in 0...(usefulBeacons.count)-3 {
                    
                    ViewController.message += "---- Time: \(time) Beacon(\(i)) Minor: \(usefulBeacons[i].minor) RSSI: \(usefulBeacons[i].rssi) Accuracy: \(usefulBeacons[i].accuracy) \n"
                    
                    ViewController.message += "---- Time: \(time) Beacon(\(i+1)) Minor: \(usefulBeacons[i+1].minor) RSSI: \(usefulBeacons[i+1].rssi) Accuracy: \(usefulBeacons[i+1].accuracy) \n"
                    
                    ViewController.message += "---- Time: \(time) Beacon(\(i+2)) Minor: \(usefulBeacons[i+2].minor) RSSI: \(usefulBeacons[i+2].rssi) Accuracy: \(usefulBeacons[i+2].accuracy) \n"
                    //updateDistance(beacons[i].proximity)
                    
                    let b1 = Int(usefulBeacons[i].minor)
                    let b2 = Int(usefulBeacons[i+1].minor)
                    let b3 = Int(usefulBeacons[i+2].minor)
                    
                    //Beacons positions in the room
                    
                    if (Position.beaconsPos[b1]?[0]) != nil{
                        posx1 = Position.beaconsPos[b1]![0]
                    }
                    if (Position.beaconsPos[b1]?[1]) != nil{
                        posy1 = Position.beaconsPos[b1]![1]
                    }
                    if (Position.beaconsPos[b2]?[0]) != nil{
                        posx2 = Position.beaconsPos[b2]![0]
                    }
                    if (Position.beaconsPos[b2]?[1]) != nil{
                        posy2 = Position.beaconsPos[b2]![1]
                    }
                    if (Position.beaconsPos[b3]?[0]) != nil{
                        posx3 = Position.beaconsPos[b3]![0]
                    }
                    if (Position.beaconsPos[b3]?[1]) != nil{
                        posy3 = Position.beaconsPos[b3]![1]
                    }
                    
                    let data = Data(beaconA: [posx1, posy1], beaconB: [posx2, posy2], beaconC: [posx3, posy3], distA: usefulBeacons[i].accuracy, distB: usefulBeacons[i+1].accuracy, distC: usefulBeacons[i+2].accuracy)
                    let pos = data.trilateration()
                    print("Trilateration position: \(pos) \n")
                    ViewController.message += "Trilateration position: \(pos) \n"
                    
                    if !(pos.0.isNaN || pos.0.isInfinite || pos.1.isNaN || pos.1.isInfinite) {
                        
                        print("Trilateration position: \(pos) \n")
                        ViewController.message += "Trilateration position: \(pos) \n"
                        
                        //Project position to the driving path
                        let projectedPosition = projectNodeToEdge(point: CLLocationCoordinate2D(latitude: pos.0, longitude: pos.1))
                        print("Projected position: \(projectedPosition) \n")
                        ViewController.message += "Projected position: \(projectedPosition) \n"
                        
                        // Add annotation to the map with the position
                        mapView.removeAnnotations(mapView.annotations)
                        
                        let point = MKPointAnnotation()
                        point.coordinate.latitude = projectedPosition.0.latitude
                        point.coordinate.longitude = projectedPosition.0.longitude
                        mapView.addAnnotation(point)
                        
                        
                        closestEdgeLat = projectedPosition.1.point1.latitude
                        switch closestEdgeLat{
                        case 51.296467:
                            Position.route[1] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296451, longitude: 1.065422),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296386, longitude: 1.065269),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296519, longitude: 1.065053))
                        case 51.296451:
                            Position.route[1] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296389, longitude: 1.065267),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296409, longitude: 1.065246),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296519, longitude: 1.065053))
                        case 51.296389:
                            Position.route[1] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296519, longitude: 1.065053))
                        case 51.296409:
                            Position.route[1] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296519, longitude: 1.065053))
                        case 51.296630:
                            let polyline = MKPolyline(coordinates: &Position.route[0].coordinates, count: 5)
                            mapView?.remove(polyline)
                            Position.route[0] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: 51.296658, longitude: 1.065181),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296635, longitude: 1.065126),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296616, longitude: 1.065144),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296641, longitude: 1.065202),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296658, longitude: 1.065181))
                            Position.route[1] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296701, longitude: 1.065161),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296708, longitude:1.065182),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296661, longitude:1.065221),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296650, longitude:1.065193))
                        default:
                            Position.route[1] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296470, longitude: 1.065455),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296386, longitude: 1.065269),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296519, longitude: 1.065053))
                        }
                        
                        addPolyline()
                    }
                    
                }
                
            }
            
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
    
}


//MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.green
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
    
    
}
