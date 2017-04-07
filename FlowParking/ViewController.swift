//
//  ViewController.swift
//  flowPark
//
//  Created by Diana Karina Vainberg Gauna and Pavlos Nicolaou on 16/02/2017.
//  Copyright © 2017 Diana Karina Vainberg Gauna and Pavlos Nicolaou. All rights reserved.
//
//  Main functionality of the whole app is in this View Controller. We are scanning to see if
//  there are beacons around the device, then get their RSSI and accuracy. Right after we get 3
//  beacons' which are close enough, we use their accuracies and predefined coordinates with a 
//  trilateration algorithm that calculates the position of the user. Afterwards, we are using an
//  algorithm that projects the position obtained to the route line that is closest to the trilateration's
//  results. We show the position of the user with a pin in the map. Also, the parking spaces are drawn in 
//  orange and we show one of them in green, which we decided randomly to be free, as a demonstration.
//  Then we show the route that the car should follow to get to that parking space in green.
//

import UIKit
import CoreLocation
import Social
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //Attaching the MapView IBOutlet from the storyboard
    @IBOutlet weak var mapView: MKMapView!
    
    static var message: String = ""
    
    //This is the position of one of the beacons we used in the experiments, 
    //and it will be the center of the map
    let latitude = 51.296634
    let longitude = 1.065126
    var locationManager: CLLocationManager!
    
    // Boolean we use to know if we need to delete a polyline from the map
    var deletePolyline = false
    // An extra polyline variable we use as an auxiliary
    var polylineAux = MKPolyline()
    //Variable used to know which edge is the closest one to the user's 
    //obtained position
    var closestEdgeLat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //Location services will be always on
        locationManager.requestAlwaysAuthorization()
        
        //Setting map view delegate with controller
        self.mapView.delegate = self
        
        print("did load")
        
        mapView.mapType = .satellite
        
        let span = MKCoordinateSpanMake(0.0015, 0.0015)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
        mapView.setRegion(region, animated: true)
        
        //Calling addPolygons when view did load to draw the parking spaces when 
        //the Map View is created
        addPolygons()
        
    }
    
    // MARK: - Function to draw the parking spaces on the map so the 
    //user can see them clearly.
    
    func addPolygons() {
        mapView?.delegate = self
        
        for space in Position.parkingSpacesList {
            let polygon = MKPolygon(coordinates: &space.coordinates, count: 4)
            
            mapView?.add(polygon)
        }
    }
    
    // MARK: - Function to draw in green a free parking space and the route line
    //to get to it.
    
    func addPolyline() {
        mapView?.delegate = self
        
        for line in Position.route {
            let polyline = MKPolyline(coordinates: &line.coordinates, count: 5)
            
            //We are checking if deletePolyline is true to delete the previous 
            //polyline and draw a new one
            if deletePolyline == true {
                //Delete the polyline from the map
                mapView?.remove(polylineAux)
                deletePolyline = false
            }
            
            //Adding the new polyline to a free parking space
            mapView?.add(polyline)
            
            //Assign the polyline to polylineAux so we can delete it right after
            //we have a new position and a new polyline
            polylineAux = polyline
            
        }
        //Delete previous polyline is true right after each loop
        deletePolyline = true
    }
    
    // MARK: - Function that takes the position of the user as a parameter and
    //returns the position projected on the road and also the closest Edge to the position
    
    func projectNodeToEdge(point: CLLocationCoordinate2D) -> (CLLocationCoordinate2D, Edge) {
        
        var dist = -1.0
        var proj = CLLocationCoordinate2D()
        var closestEdge = Edge(point1: CLLocationCoordinate2D(), point2: CLLocationCoordinate2D())
        
        //The point where the user is located is projected to each edge of the 
        //parking space, to know the distance between the point and the edge.
        //At the end the function returns the projected position to the closest
        //edge, as well as the edge itself.
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
            //Position obtained after projecting the point in the edge.
            let p = CLLocationCoordinate2D(latitude: edge.point1.latitude + abx * t, longitude: edge.point1.longitude + aby * t)
            //Calculating the distance from the point to the projected point in the edge.
            let d = distance(pA: point, pB: p)
            
            //This happens in the first loop
            if dist == -1.0{
                dist = d
                proj = p
                closestEdge = edge
            }
            //We check if the distance of this edge is smaller than the previous one,
            //if that's the case, then we save this edge and distance, otherwise,
            //we keep the previous one
            if d < dist {
                dist = d
                proj = p
                closestEdge = edge
                
            }
            
        }
        return (proj, closestEdge)
        
    }
    
    // MARK: - Function used in the ProjectNodeToEdge function to obtain the distance from
    //the position of the user to an edge of the parking space.
    
    func distance(pA: CLLocationCoordinate2D, pB: CLLocationCoordinate2D) -> Double {
        let dx = pA.latitude - pB.latitude
        let dy = pA.longitude - pB.longitude
        let distance = sqrt(dx * dx + dy * dy)
        return distance
    }
    
    
    //MARK: - Function to start monitoring and scanning for beacons.
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
    
    
    //MARK: - Function to show the map of the parking space and center it
    //in the above defined coordinates
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    //MARK: - Function to scan and range the beacons with the specified UUID
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
    
    //MARK: - Function which handles what to do with the information of the 
    //beacons found in the array called beacons. We filter the beacons to 
    //do trilateration only with the ones that have an RSSI different from zero,
    //and we use three each time we called the function. If the position obtained
    //is not NaN or infinite, then we project it to the route. Finally we add an
    //annotation in the map with the position, and show the appropriate route to 
    //the free parking space according to the obtained position.
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        
        var posx1 = 0.0
        var posy1 = 0.0
        var posx2 = 0.0
        var posy2 = 0.0
        var posx3 = 0.0
        var posy3 = 0.0
        
        
        if beacons.count > 0 {
            
            print("Found at least one beacon")
            
            //We filter the beacons so we use only the ones that have an
            //RSSI different from zero. Otherwise they can't be used to do
            //trilateration.
            let usefulBeacons = beacons.filter{$0.rssi != 0}
            
            //We now have three or more
            if usefulBeacons.count >= 3 {
                
                //We are going to do trilateration with groups of three in the
                //order they were found. For example with 1,2,3, then, 2,3,4, etc.
                for i in 0...(usefulBeacons.count)-3 {
                    
                    
                    let b1 = Int(usefulBeacons[i].minor)
                    let b2 = Int(usefulBeacons[i+1].minor)
                    let b3 = Int(usefulBeacons[i+2].minor)
                    
                    //We are getting the beacons positions in the parking area using the
                    //variable defined in Data.swift
                    
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
                    
                    //We create a Data object to which we will apply the trilateration function
                    let data = Data(beaconA: [posx1, posy1], beaconB: [posx2, posy2], beaconC: [posx3, posy3], distA: usefulBeacons[i].accuracy, distB: usefulBeacons[i+1].accuracy, distC: usefulBeacons[i+2].accuracy)
                    let pos = data.trilateration()
                    //print("Trilateration position: \(pos) \n")
                    
                    if !(pos.0.isNaN || pos.0.isInfinite || pos.1.isNaN || pos.1.isInfinite) {
                        
                        //print("Trilateration position: \(pos) \n")
                        
                        //Project position to the driving path
                        let projectedPosition = projectNodeToEdge(point: CLLocationCoordinate2D(latitude: pos.0, longitude: pos.1))
                        //print("Projected position: \(projectedPosition) \n")
                        
                        
                        //First we remove previous annotations on the map
                        mapView.removeAnnotations(mapView.annotations)
                        
                        //Here we add an annotation to the map with the position obtained
                        let point = MKPointAnnotation()
                        point.coordinate.latitude = projectedPosition.0.latitude
                        point.coordinate.longitude = projectedPosition.0.longitude
                        mapView.addAnnotation(point)
                        
                        //This part is to use an appropriate route from the obtained position
                        //to the free parking space we selected, using the closest edge to the
                        //position
                        closestEdgeLat = projectedPosition.1.point1.latitude
                        switch closestEdgeLat{
                        case 51.296467:
                            let polyline = MKPolyline(coordinates: &Position.route[0].coordinates, count: 5)
                            mapView?.remove(polyline)
                            Position.route[0] =
                                Route(edge1: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025),
                                      edge2: CLLocationCoordinate2D(latitude: 51.296531, longitude: 1.064996),
                                      edge3: CLLocationCoordinate2D(latitude: 51.296478, longitude: 1.065052),
                                      edge4: CLLocationCoordinate2D(latitude: 51.296495, longitude: 1.065078),
                                      edge5: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025))
                            Position.route[1] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296451, longitude: 1.065422),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296386, longitude: 1.065269),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296519, longitude: 1.065053))
                        case 51.296451:
                            let polyline = MKPolyline(coordinates: &Position.route[0].coordinates, count: 5)
                            mapView?.remove(polyline)
                            Position.route[0] =
                                Route(edge1: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025),
                                      edge2: CLLocationCoordinate2D(latitude: 51.296531, longitude: 1.064996),
                                      edge3: CLLocationCoordinate2D(latitude: 51.296478, longitude: 1.065052),
                                      edge4: CLLocationCoordinate2D(latitude: 51.296495, longitude: 1.065078),
                                      edge5: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025))
                            Position.route[1] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296389, longitude: 1.065267),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296409, longitude: 1.065246),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296519, longitude: 1.065053))
                        case 51.296389:
                            let polyline = MKPolyline(coordinates: &Position.route[0].coordinates, count: 5)
                            mapView?.remove(polyline)
                            Position.route[0] =
                                Route(edge1: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025),
                                      edge2: CLLocationCoordinate2D(latitude: 51.296531, longitude: 1.064996),
                                      edge3: CLLocationCoordinate2D(latitude: 51.296478, longitude: 1.065052),
                                      edge4: CLLocationCoordinate2D(latitude: 51.296495, longitude: 1.065078),
                                      edge5: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025))
                            Position.route[1] =
                                Route(
                                    edge1: CLLocationCoordinate2D(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude),
                                    edge2: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge3: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge4: CLLocationCoordinate2D(latitude: 51.296536, longitude: 1.065091),
                                    edge5: CLLocationCoordinate2D(latitude: 51.296519, longitude: 1.065053))
                        case 51.296409:
                            let polyline = MKPolyline(coordinates: &Position.route[0].coordinates, count: 5)
                            mapView?.remove(polyline)
                            Position.route[0] =
                                Route(edge1: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025),
                                      edge2: CLLocationCoordinate2D(latitude: 51.296531, longitude: 1.064996),
                                      edge3: CLLocationCoordinate2D(latitude: 51.296478, longitude: 1.065052),
                                      edge4: CLLocationCoordinate2D(latitude: 51.296495, longitude: 1.065078),
                                      edge5: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025))
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
                            let polyline = MKPolyline(coordinates: &Position.route[0].coordinates, count: 5)
                            mapView?.remove(polyline)
                            Position.route[0] =
                                Route(edge1: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025),
                                      edge2: CLLocationCoordinate2D(latitude: 51.296531, longitude: 1.064996),
                                      edge3: CLLocationCoordinate2D(latitude: 51.296478, longitude: 1.065052),
                                      edge4: CLLocationCoordinate2D(latitude: 51.296495, longitude: 1.065078),
                                      edge5: CLLocationCoordinate2D(latitude: 51.296543, longitude: 1.065025))
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
            //No beacons around Alert
            
            //Create the alert
            let alert = UIAlertController(title: "No beacons around", message: "Out of range", preferredStyle: UIAlertControllerStyle.alert)
            
            //Add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            //Show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


// MARK: - Extension MKMapViewDelegate
// Choosing the color and line size of both Polylines and Polygones

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
