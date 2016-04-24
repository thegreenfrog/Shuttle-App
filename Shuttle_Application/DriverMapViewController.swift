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
        
        let viewHeight = self.view.frame.height //- (self.navigationController?.navigationBar.frame.height)!
       
        
        mapView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        mapView.heightAnchor.constraintEqualToConstant(viewHeight * 7 / 8).active = true
        
        
        refreshButton.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
//        refreshButton.heightAnchor.constraintEqualToConstant(viewHeight * 1 / 8).active = true
   //     refreshButton.heightAnchor.constraintLessThanOrEqualToAnchor(self.view.heightAnchor, multiplier: 5.00).active = true
        refreshButton.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true

        
        //Need to get rid of navbar at bottom, get rid of uimessup at top
        
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
//        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: (self.navigationController?.navigationBar.frame.height)!).active = true
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        
    }
    
    func tapRefreshButton(recognizer:UITapGestureRecognizer){
        print("z")
        
        //It works!
        
        //Now refresh
    }

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawScreen()
        resetViewLocation = true
        mapView.mapType = .Standard
        mapView.delegate = self
        
        var refreshButtonTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapRefreshButton:")
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
    
    func queryParseForPins(){
        
        let query: PFQuery = PFQuery(className: "Request")
        
        var lat = [Double]()
        var long = [Double]()
        
        var objects = [NSObject]()
        
        query.findObjectsInBackgroundWithBlock { (obj, error) -> Void in
            
            var object: NSArray = obj! as NSArray
            for x in object {
                print(x)
                let lat = x["latitude"]!!.doubleValue
                let longit =  x["longitude"]!!.doubleValue
                print(lat)
                print(longit)
                
                self.dropRequestPins(lat, longitude: longit)
            }
            //reload data
        }
        
    }
    
    
    
    func dropRequestPins(latitude: Double, longitude: Double){
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude) , CLLocationDegrees(longitude))
        
        let pin = StopRequest(title: "req", locationName: "this", coordinate: coordinate)
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
