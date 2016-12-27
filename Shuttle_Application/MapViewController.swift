//
//  MapViewController.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 2/28/16.
//
//

import UIKit
import MapKit
import QuartzCore
import Parse

class MapViewController: UIViewController, MKMapViewDelegate {
    
    struct Constants {
        static let driverComing = "driverComing"
        static let Brunswick:CLLocation = CLLocation(latitude: 43.9108, longitude: -69.9631)
        static let MapRadius:CLLocationDistance = 1000
        static let pinImageFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 45, height: 45))
        static let pinLabelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 50))
        static let nameCoordinateHash = ["Appleton": CLLocationCoordinate2D(latitude: 43.906982, longitude: -69.962232)]
    }
    
    enum MapType: Int {
        case Standard = 0
        case Hybrid
        case Satellite
    }
    
    //var dataSourceDelegate: PickupLocationTableVCDelegate?
    
    var geoCoder = CLGeocoder()
    
    var resetViewLocation = true//only recenters user view of map at the start
    
    var loadingIndicator: UIActivityIndicatorView?
    var pinImage: UIImageView?
    var pinLabel: UIButton?
    var timer: NSTimer?
    var waitingLabelToggle = true

    var waitingView: UIView!
    
    var waitingOnDriver = false
    
    var address: UILabel!
    var currentAddress: String?

    func drawScreen() {
        address = UILabel()
        address.numberOfLines = 0
        address.backgroundColor = UIColor.lightGrayColor()
        address.textColor = UIColor.blackColor()
        address.textAlignment = .Center
        address.translatesAutoresizingMaskIntoConstraints = false
        
        waitingView = UIView()

        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(address)
        screenStackView.addArrangedSubview(waitingView)
        
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Fill
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenStackView)
        
        let viewHeight = self.view.frame.height
        waitingView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        waitingView.heightAnchor.constraintEqualToConstant(viewHeight * 7/8).active = true

        address.heightAnchor.constraintEqualToConstant(viewHeight * 1 / 8).active = true
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: (self.tabBarController?.tabBar.frame.height)!).active = true
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        
    }
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Uber Bowdoin"
        
        drawScreen()
        resetViewLocation = true
        
       // navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self.revealViewController(), action: "revealToggle:")
        
        // Ask for Authorisation from the User.
             //allows screen to change states after driver accepts user pickup request
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "driverOnTheWay:", name: Constants.driverComing, object: nil)
    
        //create label above pin
        pinLabel = UIButton(frame: Constants.pinLabelFrame)
        pinLabel!.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        pinLabel!.setTitle("Set a pickup location", forState: .Normal)
        pinLabel!.setTitleColor(UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0), forState: .Normal)
        pinLabel!.layer.masksToBounds = true
        pinLabel!.layer.cornerRadius = 10
        pinLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pinLabel!)
        pinLabel?.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        pinLabel?.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: (navigationController?.navigationBar.frame.height)!-40).active = true
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if let z = UIApplication.sharedApplication().delegate as? AppDelegate {
            if let m = z.shouldNotBeDoingThis {
                
                if !waitingOnDriver{
                    self.address.text = m
                    pickUpPerson(m)
                }

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Map Functions

    // MARK: - Pin Functions
    
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
                self.waitingOnDriver = false
                return
            }
            
            if let req = obj {
                req.deleteInBackgroundWithBlock({ (succ, err) -> Void in
                    if !succ || err != nil {
                        print("delete not successful")
                        self.waitingOnDriver = false
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
                    self.waitingOnDriver = false
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
    func pickUpPerson(pickUpLocation: String) {
        
        let pickUpLoc = Constants.nameCoordinateHash[pickUpLocation]
        
        let pickUpObject = PFObject.init(className: "Request")
        pickUpObject.setObject("\(pickUpLoc!.latitude)", forKey: "latitude")
        pickUpObject.setObject("\(pickUpLoc!.longitude)", forKey: "longitude")
        pickUpObject.setObject(false, forKey: "pickedUpAlready")
        let firstName = PFUser.currentUser()?.valueForKey("firstName") as? String
        pickUpObject.setObject(firstName!, forKey: "name")
        
        let id = PFUser.currentUser()?.objectId
        pickUpObject.setObject(id!, forKey: "userObjectId")
        pickUpObject.saveInBackgroundWithBlock({ (success, error) in
            print("object saved")
        })
            //send notification to nearest driver within 10 miles
        
            self.loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            self.loadingIndicator?.userInteractionEnabled = false
            self.loadingIndicator?.translatesAutoresizingMaskIntoConstraints = false
            self.loadingIndicator?.startAnimating()
            self.view.addSubview(self.loadingIndicator!)
            self.loadingIndicator?.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
            self.loadingIndicator?.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: (self.navigationController?.navigationBar.frame.height)!).active = true
            //send notification to nearest driver within 10 miles
            waitingOnDriver = true
            self.findDriver(pickUpLoc!)
//        })
        
        pinLabel?.fadeOut(1.0, delay: 0.0, completion: { (finished: Bool) -> Void in
            self.pinLabel?.setTitle("Finding Driver", forState: .Disabled)
            self.pinLabel?.setTitle("Tap to Cancel", forState: .Normal)
         //   self.pinLabel?.removeTarget(self, action: "pickUpPersonFromButton:", forControlEvents: .TouchUpInside)
            self.pinLabel?.addTarget(self, action: "cancelRequest", forControlEvents: .TouchUpInside)
            self.pinLabel?.enabled = false
            self.pinLabel?.fadeIn(1.0, delay: 0, completion: {_ in })
            self.timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "toggleWaitingLabel", userInfo: nil, repeats: true)
        })
    }

    
    func driverOnTheWay(notification: NSNotification) {
        print("YOOO")
        pinLabel?.setTitle("Driver on the way!", forState: .Normal)
        print("driver is on the way!")
        waitingOnDriver = false
    }
    
    func showSideBar() {
//        revealToggle(self)
    }
}