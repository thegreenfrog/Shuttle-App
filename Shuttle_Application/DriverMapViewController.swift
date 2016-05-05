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

    var mapView: MKMapView!
    
    var refreshLabel: UIView!
    var refreshButton: UIButton!
    var hidingRefreshBottomLayout: NSLayoutConstraint!
    var showRefreshBottomLayout: NSLayoutConstraint!
    var userMovedMap = false
    var buttonShown = false
    
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
        refreshLabel = UIView()
        refreshLabel.hidden = false
        refreshLabel.backgroundColor = UIColor.lightGrayColor()
        refreshLabel.translatesAutoresizingMaskIntoConstraints = false
        refreshButton = UIButton()
        refreshButton.backgroundColor = UIColor.whiteColor()
        refreshButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        refreshButton.setTitle("Refresh Map", forState: .Normal)
        refreshButton.addTarget(self, action: "tapRefreshButton", forControlEvents: .TouchUpInside)
        refreshButton.layer.cornerRadius = 10
        refreshButton.clipsToBounds = true
        refreshButton.translatesAutoresizingMaskIntoConstraints = false

        
        
        mapView = MKMapView()
        mapView.mapType = .Standard
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(mapView)
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Fill
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(screenStackView)
        self.view.addSubview(refreshButton)
        self.view.bringSubviewToFront(refreshButton)
        refreshButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        hidingRefreshBottomLayout = refreshButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 45)
        hidingRefreshBottomLayout.active = true
        showRefreshBottomLayout = refreshButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 0)
        showRefreshBottomLayout.active = false
        
        refreshButton.widthAnchor.constraintEqualToConstant(160).active = true
        refreshButton.heightAnchor.constraintEqualToConstant(45).active = true


        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        screenStackView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
        
    }
    
    

/* Refresh button action */
    func tapRefreshButton(){
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
        UIView.animateWithDuration(1.5, delay: 0.0, options: .TransitionCurlUp, animations: {
            self.showRefreshBottomLayout.active = false
            self.hidingRefreshBottomLayout.active = true
            self.buttonShown = false
            }, completion: nil)
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawScreen()
        resetViewLocation = true
        mapView.mapType = .Standard
        mapView.delegate = self
        
        //refreshLabel.addTarget(self, action: "tapRefreshButton", forControlEvents: .TouchUpInside)
        
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
       // dropStopLocationPins()
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
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        //determine if user initiated change in map region
        let view = mapView.subviews.first
        if let recognizers = view?.gestureRecognizers {
            for gesture in recognizers {
                if gesture.state == UIGestureRecognizerState.Began || gesture.state == UIGestureRecognizerState.Ended {
                    userMovedMap = true
                    break;
                }
            }
        }
        
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //show refresh map button if the button has not been shown yet and user initiated moving of map region
        if userMovedMap && !buttonShown{
            UIView.animateWithDuration(1.0, delay: 0.0, options: .TransitionCurlUp, animations: {
                    self.hidingRefreshBottomLayout.active = false
                    self.showRefreshBottomLayout.active = true
                }, completion: nil)
            buttonShown = true
            userMovedMap = false
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
        
        let ok = UIAlertAction(title: "OK", style: .Default) {
            (_) in self.handleOK(view.annotation?.title) //self.handleOK(view)
        }
        
        
        //add action function
        
        alertController.addAction(cancel)
        alertController.addAction(ok)
        
        
        
       // let push = PFPush()
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func handleOK(annotationView: MKAnnotationView){
        let studentID = annotationView.annotation?.title!!
        
        let reqQuery = PFQuery(className: "Request")
        reqQuery.whereKey("objectId", equalTo: studentID!)
        reqQuery.getFirstObjectInBackgroundWithBlock({ (objects, err) -> Void in
            if let req = objects {
                
                let userID = req["userObjectId"] as! String
                
                let userQuery = PFUser.query()
                userQuery?.whereKey("objectId", equalTo: userID)
                
                let installationUser = PFInstallation.query()
                
                installationUser?.whereKey("user", matchesQuery: userQuery!)
                
                let push = PFPush()
                
                push.setQuery(installationUser)
                push.setMessage("A drive will be coming to you!")
                push.sendPushInBackground()
                
               // annotationView.removeFromSuperview()
              //  annotationView.tintColor = UIColor.greenColor()
            }
        })

    }
    
    
    func handleOK(title: String??){
        
        print("yo")
        
        let studentID = title!!
        
        let reqQuery = PFQuery(className: "Request")
        reqQuery.whereKey("objectId", equalTo: studentID)
        reqQuery.getFirstObjectInBackgroundWithBlock({ (objects, err) -> Void in
            if let req = objects {
                
                let userID = req["userObjectId"] as! String
                
                let userQuery = PFUser.query()
                userQuery?.whereKey("objectId", equalTo: userID)
                
                let installationUser = PFInstallation.query()
                
                installationUser?.whereKey("user", matchesQuery: userQuery!)
                
                let push = PFPush()
                
                push.setQuery(installationUser)
                push.setMessage("A drive will be coming to you!")
                push.sendPushInBackground()
                
            }
        })
        
        
        /*
        var query: PFQuery = PFUser.query()!
        query.whereKey("objectId", equalTo: studentID)
        
        
        
        let userID: PFQuery = PFUser.query()!
        
        
        let intallationUser = PFInstallation.query()
        intallationUser?.whereKey("user", matchesQuery: query)
        
        let push = PFPush()
        push.setQuery(intallationUser)
        push.setMessage("A driver will be coming to you!")
        push.sendPushInBackground()
        
        print("hello there")
        */
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
