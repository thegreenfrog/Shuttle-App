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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
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
    
    let locationManager = CLLocationManager()
    var resetViewLocation = true//only recenters user view of map at the start
    
    var pinImage:UIImageView?
    var pinLabel:UILabel?

    @IBOutlet weak var mapSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Lifecycle
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetViewLocation = true
        mapView.mapType = .Standard
        mapView.delegate = self
        
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
        self.view.addSubview(pinImage!)
        
        //create label above pin
        pinLabel = UILabel(frame: Constants.pinLabelFrame)
        pinLabel!.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        pinLabel!.center = CGPoint(x: self.view.center.x, y: self.view.center.y-60)
        pinLabel!.text = "Set a pickup location"
        pinLabel!.textColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        pinLabel!.textAlignment = .Center
        pinLabel!.layer.masksToBounds = true
        pinLabel!.layer.cornerRadius = 20
        self.view.addSubview(pinLabel!)
        
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

    
    // MARK: - Pin Annotation Functioons
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
