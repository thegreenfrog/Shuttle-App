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
        static let pinImageFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 45, height: 45))
        static let pinLabelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 50))
    }
    
    enum MapType: Int {
        case Standard = 0
        case Hybrid
        case Satellite
    }
    
    private var requestLog = RequestLog()
    private var tabBarVC = RequestTabBarController()
    var geoCoder = CLGeocoder()
    
    let locationManager = CLLocationManager()
    var resetViewLocation = true//only recenters user view of map at the start
    
    var pinImage:UIImageView?
    var pinLabel:UIButton?
    
    
    @IBOutlet weak var mapSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var address: UILabel!
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
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tabBarVC = tabBarController as! RequestTabBarController
        //requestLog = tabBarVC.request
        
        resetViewLocation = true
        mapView.mapType = .Standard
        mapView.delegate = self
        mapView.setCenterCoordinate(Constants.Brunswick.coordinate, animated: true)
        //add region (zoom level)
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
            //mapView.showsUserLocation = true
        }
        
        //create and render pinImageIcon
        pinImage = UIImageView(frame: Constants.pinImageFrame)
        pinImage?.center = self.view.center
        pinImage?.image = UIImage(named: "location")
        pinImage!.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pinImage!)
        
        let imageXConstraint = NSLayoutConstraint(item: pinImage!, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let imageYConstraint = NSLayoutConstraint(item: pinImage!, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(imageXConstraint)
        self.view.addConstraint(imageYConstraint)
        
        
        //create label above pin
        pinLabel = UIButton(frame: Constants.pinLabelFrame)
        pinLabel!.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        
        pinLabel!.setTitle("Set a pickup location", forState: .Normal)
        pinLabel!.setTitleColor(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0), forState: .Normal)
        pinLabel!.layer.masksToBounds = true
        pinLabel!.layer.cornerRadius = 20
        pinLabel?.addTarget(self, action: "pickUpPerson:", forControlEvents: .TouchUpInside)
        pinLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pinLabel!)
        
        let labelXConstraint = NSLayoutConstraint(item: pinLabel!, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let labelYConstraint = NSLayoutConstraint(item: pinLabel!, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -40)
        self.view.addConstraint(labelXConstraint)
        self.view.addConstraint(labelYConstraint)
        
        let dropPinGesture = UILongPressGestureRecognizer(target: self, action: Selector("dropPin:"))
        mapView.addGestureRecognizer(dropPinGesture)
        mapSegmentedControl.selectedSegmentIndex = 2
        addRoute()
        dropStopLocationPins()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map Functions
    
    @IBAction func changeMapType(sender: UISegmentedControl) {
        let mapType = MapType(rawValue: mapSegmentedControl.selectedSegmentIndex)
        switch (mapType!) {
        case .Standard:
            mapView.mapType = MKMapType.Standard
        case .Hybrid:
            mapView.mapType = MKMapType.Hybrid
        case .Satellite:
            mapView.mapType = MKMapType.Satellite
        }
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
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case is MKPolyline:
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.lightGrayColor()
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
    
    //user wants to get picked up at curent center location in map
    func pickUpPerson(sender: UIButton!) {
        let pickUpLoc = self.mapView.centerCoordinate
        //let newReq = Request(addr: currentAddress!, loc: pickUpLoc)
        let pickUpObject = PFObject.init(className: "Request")
        pickUpObject.setObject("\(pickUpLoc.latitude)", forKey: "latitude")
        pickUpObject.setObject("\(pickUpLoc.longitude)", forKey: "longitude")
        //pickUpObject.setObject(pickUpLoc, forKey: "location")
        pickUpObject.setObject(currentAddress!, forKey: "address")
        pickUpObject.saveInBackgroundWithBlock({ (success, error) in
            print("object saved")
        })
        pinImage?.fadeOut(1.0, delay: 0, completion: {(finished: Bool) -> Void in
            //remove pin image from view and also remove all of its constraints
            self.pinImage?.removeConstraints()
            self.pinImage?.removeFromSuperview()
            //show loading indicator in place of pin image
            let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            loadingIndicator.userInteractionEnabled = false
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.startAnimating()
            self.view.addSubview(loadingIndicator)
            let loadingXConstraint = NSLayoutConstraint(item: loadingIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
            let loadingYConstraint = NSLayoutConstraint(item: loadingIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
            self.view.addConstraint(loadingXConstraint)
            self.view.addConstraint(loadingYConstraint)
        })
        pinLabel?.fadeOut(1.0, delay: 0.0, completion: { (finished: Bool) -> Void in
            self.pinLabel?.setTitle("Finding Driver", forState: .Disabled)
            self.pinLabel?.enabled = false
            self.pinLabel?.fadeIn(1.0, delay: 0, completion: {_ in })
        })
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
