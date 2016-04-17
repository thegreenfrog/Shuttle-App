//
//  WelcomeViewController.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 4/6/16.
//
//

import UIKit

class WelcomeViewController: UIViewController {

    struct Constants {
        static let buttonFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 45))
        static let labelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 225, height: 100))
    }
    var driverButton: UIButton!
    var userButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let welcomeLabel = UILabel(frame: Constants.buttonFrame)
        welcomeLabel.backgroundColor = UIColor(red: 244/255, green: 164/255, blue: 96/255, alpha: 1.0)
        welcomeLabel.numberOfLines = 0
        welcomeLabel.text = "Welcome! Register as:"
        welcomeLabel.textAlignment = .Center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(welcomeLabel)
        let welcomeXConstraint = NSLayoutConstraint(item: welcomeLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let welcomeYConstraint = NSLayoutConstraint(item: welcomeLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -60)
        self.view.addConstraint(welcomeXConstraint)
        self.view.addConstraint(welcomeYConstraint)
        
        
        driverButton = UIButton(frame: Constants.buttonFrame)
        driverButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        driverButton.setTitle("Driver", forState: .Normal)
        driverButton.layer.masksToBounds = true
        driverButton.layer.cornerRadius = 15
        driverButton.addTarget(self, action: "segueToDriverSignin", forControlEvents: .TouchUpInside)
        driverButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(driverButton)
        let driverXConstraint = NSLayoutConstraint(item: driverButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let driverYConstraint = NSLayoutConstraint(item: driverButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 40)
        self.view.addConstraint(driverXConstraint)
        self.view.addConstraint(driverYConstraint)
        
        userButton = UIButton(frame: Constants.buttonFrame)
        userButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        userButton.setTitle("User", forState: .Normal)
        userButton.layer.masksToBounds = true
        userButton.layer.cornerRadius = 15
        userButton.addTarget(self, action: "segueToUserSignin", forControlEvents: .TouchUpInside)
        userButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(userButton)
        let userXConstraint = NSLayoutConstraint(item: userButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let userYConstraint = NSLayoutConstraint(item: userButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 100)
        self.view.addConstraint(userXConstraint)
        self.view.addConstraint(userYConstraint)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueToDriverSignin() {
        let driverVC = DriverRegisterViewController()
        presentViewController(driverVC, animated: true, completion: nil)
        
    }
    
    func segueToUserSignin() {
        let userVC = UserRegisterViewController()
        presentViewController(userVC, animated: true, completion: nil)
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
