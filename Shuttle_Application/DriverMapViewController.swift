//
//  DriverMapViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 4/17/16.
//
//

import UIKit
import MapKit
import CoreLocation
import QuartzCore
import Parse

class DriverMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    struct Constants {
        static let Brunswick:CLLocation = CLLocation(latitude: 43.9108, longitude: -69.9631)
        static let MapRadius:CLLocationDistance = 1000
    }
    
    enum MapType: Int {
        case Standard = 0
        case Hybrid
        case Satellite
    }
    
    var geoCoder = CLGeocoder()
    
    var requestDict = Dictionary<String, Int>()
    
    
    let locationManager = CLLocationManager()
    var resetViewLocation = true//only recenters user view of map at the start
    
    var pinImage:UIImageView?
    var pinLabel:UIButton?
    
    var mapView: MKMapView!
    
    var refreshButton: UIButton!
    var currentAddress: String?
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        if(resetViewLocation) {
            let center = CLLocationCoordinate2D(latitude: Constants.Brunswick.coordinate.latitude, longitude: Constants.Brunswick.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
            
            //THIS ZOOMS OUR REGION IN...............................
            
            resetViewLocation = false
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    func drawScreen() {
        refreshButton = UIButton()
        refreshButton.backgroundColor = UIColor.lightGrayColor()
        refreshButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        refreshButton.setTitle("Refresh Pins", forState: .Normal)
        
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        mapView = MKMapView()
        mapView.mapType = .Standard
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(refreshButton)
        screenStackView.addArrangedSubview(mapView)
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Fill
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(screenStackView)
        
        let viewHeight = self.view.frame.height
       
        mapView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        mapView.heightAnchor.constraintEqualToConstant(viewHeight * 7 / 8).active = true
        
        
        refreshButton.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        refreshButton.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true

        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        
    }

/* Refresh button action */
    func tapRefreshButton(recognizer:UITapGestureRecognizer){
        print("z")
        
        
        let query: PFQuery = PFQuery(className: "Request")
        
        query.findObjectsInBackgroundWithBlock { (obj, error) -> Void in
            
            let object: NSArray = obj! as NSArray
            for x in object {
                
                if self.requestDict[x.objectId!!] == nil {
                    let lat = x["latitude"]!!.doubleValue
                    let longit =  x["longitude"]!!.doubleValue
                    let id = x.objectId!!
                    
                    self.dropRequestPins(lat, longitude: longit, requestID: id)
                    
                }
            
            }
            //reload data
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawScreen()
        resetViewLocation = true
        mapView.mapType = .Standard
        mapView.delegate = self
        
        let refreshButtonTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapRefreshButton:")
        refreshButton.addGestureRecognizer(refreshButtonTap)
        
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.requestLocation()
            //mapView.showsUserLocation = true
        }
        
        addRoute()
        dropStopLocationPins()
        queryParseForPins()
        
    }
    
/* Queries parse for pins that represent pickup requests */
    func queryParseForPins(){
        
        let query: PFQuery = PFQuery(className: "Request")
        
        query.findObjectsInBackgroundWithBlock { (obj, error) -> Void in
            
            let object: NSArray = obj! as NSArray
            for x in object {
                
                let lat = x["latitude"]!!.doubleValue
                let longit =  x["longitude"]!!.doubleValue
                let id = x.objectId!!
                self.dropRequestPins(lat, longitude: longit, requestID: id)
            }
            //reload data
        }
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StopRequest {
            let identifier = "pinId"
            var view: MKPinAnnotationView
            if let dequeuedPin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView{
                dequeuedPin.annotation = annotation
                view = dequeuedPin
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            view.draggable = true
            return view
        }
        return nil
    }
    
/* Function makes it so when youclick the calloutAccessory we display a UIAlertController */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){

        var alertController = UIAlertController(title: "Pick up this student?", message: "If you select 'OK', this student will be added to your queue.", preferredStyle: .Alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        let ok = UIAlertAction(title: "OK", style: .Default) { (_) in }
        //add action function
        
        alertController.addAction(cancel)
        alertController.addAction(ok)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
/* Drops pins for given requests on map onLoad */
    func dropRequestPins(latitude: Double, longitude: Double, requestID: String){
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude) , CLLocationDegrees(longitude))
        
        requestDict[requestID] = 1
        
        let pin = StopRequest(title: requestID, locationName: "this", coordinate: coordinate)
        mapView.addAnnotation(pin)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func dropStopLocationPins() {
        let thePath = NSBundle.mainBundle().pathForResource("RouteCoord", ofType: "plist")
        let pointsDict = NSDictionary(contentsOfFile: thePath!)
        
        for (name, location) in pointsDict! {
            let p = CGPointFromString(location as! String)
            let location = CLLocationCoordinate2DMake(CLLocationDegrees(p.x), CLLocationDegrees(p.y))
            let pin = StopRequest(title: name as! String, locationName: "Bowdoin", coordinate: location)
            
            mapView.addAnnotation(pin)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addRoute() {
        let thePath = NSBundle.mainBundle().pathForResource("RoutePath", ofType: "plist")
        let stopsArray = NSArray(contentsOfFile: thePath!)
        
        let stopsCount = stopsArray?.count
        
        var pointsToUse: [CLLocationCoordinate2D] = []
        
        for i in 0...stopsCount!-1 {
            let p = CGPointFromString(stopsArray![i] as! String)
            let location = CLLocationCoordinate2DMake(CLLocationDegrees(p.x), CLLocationDegrees(p.y))
            pointsToUse += [location]
        }
        
        let myPolyline = MKPolyline(coordinates: &pointsToUse, count: stopsCount!)
        
        mapView.addOverlay(myPolyline)
    }

    
}
