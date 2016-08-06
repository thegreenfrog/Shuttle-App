//
//  MapViewController.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 2/28/16.
//
//

import UIKit
import MapKit
import CoreLocation
import QuartzCore
import Parse

//protocol PickupLocationTableVCDelegate {
//    func returnUserSelectedLocation() -> String?
//}

protocol FooTwoViewControllerDelegate: class {
    func myVCDidFinish(text:String) -> String
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    struct Constants {
        static let driverComing = "driverComing"
        static let Brunswick:CLLocation = CLLocation(latitude: 43.9108, longitude: -69.9631)
        static let MapRadius:CLLocationDistance = 1000
        static let pinImageFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 45, height: 45))
        static let pinLabelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 50))
        static let Appleton = ("Appleton", CLLocationCoordinate2D(latitude: 43.906982, longitude: -69.962232))
    }
    
    enum MapType: Int {
        case Standard = 0
        case Hybrid
        case Satellite
    }
    
    //var dataSourceDelegate: PickupLocationTableVCDelegate?
    
    var geoCoder = CLGeocoder()
    
    let locationManager = CLLocationManager()
    var resetViewLocation = true//only recenters user view of map at the start
    
    var loadingIndicator: UIActivityIndicatorView?
    var pinImage: UIImageView?
    var pinLabel: UIButton?
    var timer: NSTimer?
    var waitingLabelToggle = true

    var mapView: MKMapView!

    var address: UILabel!
    var currentAddress: String?
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        if(resetViewLocation) {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self.mapView.setRegion(region, animated: true)
            resetViewLocation = false
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }

    func drawScreen() {
        address = UILabel()
        address.numberOfLines = 0
        address.backgroundColor = UIColor.lightGrayColor()
        address.textColor = UIColor.blackColor()
        address.textAlignment = .Center
        address.translatesAutoresizingMaskIntoConstraints = false
        
        mapView = MKMapView()
        mapView.mapType = .Standard
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(address)
        screenStackView.addArrangedSubview(mapView)
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Fill
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenStackView)
        
        let viewHeight = self.view.frame.height
        mapView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        mapView.heightAnchor.constraintEqualToConstant(viewHeight * 7 / 8).active = true
        address.heightAnchor.constraintEqualToConstant(viewHeight * 1 / 8).active = true
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        
       screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: (self.tabBarController?.tabBar.frame.height)!).active = true

        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        
    }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(animated: Bool) {
        /*
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if let location = appDelegate.shouldNotBeDoingThis {
            
            var myLocation = CLLocation(latitude: Constants[location].0 , longitude: Constants[location].1)
            
            centerMaponLoc(Constants.Appleton.1)
            
        }
        
        appDelegate.shouldNotBeDoingThis = nil
        
         */
        /*
         var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         appDelegate.shouldNotBeDoingThis = "Appleton"
    */
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Uber Bowdoin"
        print("ASDSDASDASDASDASDASDSADASDASDASDADASASDA")
        
        drawScreen()
        resetViewLocation = true
        mapView.mapType = .Standard
        mapView.delegate = self
        
        
        
        
       // navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self.revealViewController(), action: "revealToggle:")
        
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
        
        //allows screen to change states after driver accepts user pickup request
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "driverOnTheWay:", name: Constants.driverComing, object: nil)
    
        //create and render pinImageIcon
        pinImage = UIImageView(frame: Constants.pinImageFrame)
        pinImage?.center = self.view.center
        pinImage?.image = UIImage(named: "location")
        pinImage!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pinImage!)
        pinImage?.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        pinImage?.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: (navigationController?.navigationBar.frame.height)!).active = true
        
        
        //create label above pin
        pinLabel = UIButton(frame: Constants.pinLabelFrame)
        pinLabel!.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        pinLabel!.setTitle("Set a pickup location", forState: .Normal)
        pinLabel!.setTitleColor(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0), forState: .Normal)
        pinLabel!.layer.masksToBounds = true
        pinLabel!.layer.cornerRadius = 10
        pinLabel?.addTarget(self, action: "pickUpPerson:", forControlEvents: .TouchUpInside)
        pinLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pinLabel!)
        pinLabel?.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        pinLabel?.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: (navigationController?.navigationBar.frame.height)!-40).active = true
        
        let dropPinGesture = UILongPressGestureRecognizer(target: self, action: Selector("dropPin:"))
        mapView.addGestureRecognizer(dropPinGesture)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let z = UIApplication.sharedApplication().delegate as? AppDelegate {
            
            if let m = z.shouldNotBeDoingThis {
                print(m)
            }
            
        }
        
       // var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        
        
//            let userDestinationLocation = self.dataSourceDelegate?.returnUserSelectedLocation()
//            print(userDestinationLocation)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map Functions
    
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
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case is MKPolyline:
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.blueColor()
            lineView.lineWidth = 5.0
            lineView.lineCap = .Round
            return lineView
        default:
            return MKPolylineRenderer()
        }
    }
    
    func coordToGeo(loc: CLLocation) {
        //Only one reverse geocoding can be in progress at a time so we need to cancel any existing ones
        
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(loc, completionHandler: { (data, error) -> Void in
            guard let placeMarks = data as [CLPlacemark]! else {
                return
            }
            let loc: CLPlacemark = placeMarks[0]
            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            let address = addrList.joinWithSeparator(", ")
            print(address)
            self.address.text = address
            self.currentAddress = address
        })
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        coordToGeo(location)
    }

    
    // MARK: - Pin Functions
    
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
    
    func dropPin(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began {
            let coordinate = mapView.convertPoint(gesture.locationInView(mapView), toCoordinateFromView: mapView)
            let pin = StopRequest(title: "dopped pin", locationName: "Brunswick", coordinate: coordinate)
            mapView.addAnnotation(pin)
        }
    }
    
    func centerMaponLoc(location: CLLocation) {
        let coordinates = MKCoordinateRegionMakeWithDistance(location.coordinate, Constants.MapRadius * 2, Constants.MapRadius * 2)
        mapView.setRegion(coordinates, animated: true)
    }
    
    func setDragState(view: MKAnnotationView, newDragState: MKAnnotationViewDragState, animated: Bool) {
        switch(newDragState) {
        case .Starting:
            view.dragState = .Dragging
            return
        case .Canceling:
            view.dragState = .None
            return
        case .Ending:
            view.dragState = .None
            return
        default:
            return
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
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        for pins in views {
            let endFrame = pins.frame
            pins.frame = CGRectOffset(endFrame, 0, -500)
            UIView.animateWithDuration(0.5, animations: {() in
                pins.frame = endFrame
                }, completion: {(bool) in
                    UIView.animateWithDuration(0.05, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
                        pins.transform = CGAffineTransformMakeScale(1.0, 0.6)
                        }, completion: {(Bool) in
                            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations:{() in
                                pins.transform = CGAffineTransformIdentity
                                }, completion: nil)
                    })
                }
            )
        }
    }
    
    //helper function that pings nearest drivers until one accepts
    func findDriver(loc: CLLocationCoordinate2D) {
        print(loc.latitude, loc.longitude)
        //find drivers
        let geoPoint = PFGeoPoint(latitude: loc.latitude, longitude: loc.longitude)
        
        let userQuery = PFUser.query()
        userQuery?.whereKey("location", nearGeoPoint: geoPoint)

        let driverQuery = PFInstallation.query()
        driverQuery!.whereKey("channels", equalTo: "drivers")
        driverQuery!.whereKey("user", matchesQuery: userQuery!)
        
        
    }
    
    func cancelRequest() {
        //get most recent request made by the user
        let userId = PFUser.currentUser()?.objectId
        let getReq = PFQuery(className: "Request")
        getReq.whereKey("userObjectId", equalTo: userId!)
        getReq.orderByDescending("createdAt")
        getReq.getFirstObjectInBackgroundWithBlock({ (obj, err) -> Void in
            if err != nil {
                let alert = UIAlertController(title: "Could not cancel", message: "\(err)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            if let req = obj {
                let addr = req.valueForKey("address") as! String
                print("\(addr)")
                req.deleteInBackgroundWithBlock({ (succ, err) -> Void in
                    if !succ || err != nil {
                        print("delete not successful")
                        return
                    }
                    let alert = UIAlertController(title: "Cancel Sucessful", message: "", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    //restore original view
                    self.loadingIndicator?.removeFromSuperview()
                    self.loadingIndicator = nil
                    self.timer?.invalidate()
                    self.pinLabel!.setTitle("Set a pickup location", forState: .Normal)
                    self.pinLabel?.removeTarget(self, action: "cancelRequest", forControlEvents: .TouchUpInside)
                    self.pinLabel?.addTarget(self, action: "pickUpPerson:", forControlEvents: .TouchUpInside)
                    self.pinImage = UIImageView(frame: Constants.pinImageFrame)
                    self.pinImage?.center = self.view.center
                    self.pinImage?.image = UIImage(named: "location")
                    self.pinImage!.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(self.pinImage!)
                    self.pinImage?.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                    self.pinImage?.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: (self.navigationController?.navigationBar.frame.height)!).active = true
                    return
                })
            }
        })
        
    }
    
    //swap label text so user knows how to cancel request
    func toggleWaitingLabel() {
        if !waitingLabelToggle {
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {() in
                self.pinLabel?.enabled = true
                }, completion: nil)
            
        } else {
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {() in
                self.pinLabel?.enabled = false
                }, completion: nil)
        }
        waitingLabelToggle = !waitingLabelToggle
    }
    
    //user wants to get picked up at curent center location in map
    func pickUpPerson(sender: UIButton!) {
        let pickUpLoc = self.mapView.centerCoordinate
        
        
        
        //let newReq = Request(addr: currentAddress!, loc: pickUpLoc)
        let pickUpObject = PFObject.init(className: "Request")
        pickUpObject.setObject("\(pickUpLoc.latitude)", forKey: "latitude")
        pickUpObject.setObject("\(pickUpLoc.longitude)", forKey: "longitude")
        pickUpObject.setObject(currentAddress!, forKey: "address")
        pickUpObject.setObject(false, forKey: "pickedUpAlready")
        let firstName = PFUser.currentUser()?.valueForKey("firstName") as? String
        pickUpObject.setObject(firstName!, forKey: "name")
        
        let id = PFUser.currentUser()?.objectId
        pickUpObject.setObject(id!, forKey: "userObjectId")
        pickUpObject.saveInBackgroundWithBlock({ (success, error) in
            print("object saved")
        })
        
        pinImage?.fadeOut(1.0, delay: 0, completion: {(finished: Bool) -> Void in
            //remove pin image from view and also remove all of its constraints
            self.pinImage?.removeConstraints()
            self.pinImage?.removeFromSuperview()
            self.pinImage = nil
            //show loading indicator in place of pin image
            self.loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            self.loadingIndicator?.userInteractionEnabled = false
            self.loadingIndicator?.translatesAutoresizingMaskIntoConstraints = false
            self.loadingIndicator?.startAnimating()
            self.view.addSubview(self.loadingIndicator!)
            self.loadingIndicator?.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
            self.loadingIndicator?.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: (self.navigationController?.navigationBar.frame.height)!).active = true
            
            //send notification to nearest driver within 10 miles
            self.findDriver(pickUpLoc)
        })
        pinLabel?.fadeOut(1.0, delay: 0.0, completion: { (finished: Bool) -> Void in
            self.pinLabel?.setTitle("Finding Driver", forState: .Disabled)
            self.pinLabel?.setTitle("Tap to Cancel", forState: .Normal)
            self.pinLabel?.removeTarget(self, action: "pickUpPerson:", forControlEvents: .TouchUpInside)
            self.pinLabel?.addTarget(self, action: "cancelRequest", forControlEvents: .TouchUpInside)
            self.pinLabel?.enabled = false
            self.pinLabel?.fadeIn(1.0, delay: 0, completion: {_ in })
            self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "toggleWaitingLabel", userInfo: nil, repeats: true)
        })
    }
    
    func driverOnTheWay(notification: NSNotification) {
        print("driver is on the way!")
        //remove loadingIndicator
        loadingIndicator?.removeFromSuperview()
        loadingIndicator = nil
        pinLabel?.removeFromSuperview()
        pinLabel = nil
    }
    
    func showSideBar() {
//        revealToggle(self)
    }

}
