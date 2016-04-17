//
//  DriverRegisterViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 4/7/16.
//
//

import UIKit

class DriverRegisterViewController: UIViewController {

    struct Constants {
    static let buttonFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 45))
    static let labelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 225, height: 100))
    }
    
    var signInButton: UIButton!
    var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton = UIButton(frame: Constants.buttonFrame)
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        signInButton.layer.masksToBounds = true
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        let signInXConstraint = NSLayoutConstraint(item: signInButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let signInYConstraint = NSLayoutConstraint(item: signInButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 40)
        self.view.addConstraint(signInXConstraint)
        self.view.addConstraint(signInYConstraint)
        signInButton.addTarget(self, action: "showSignInForDriver", forControlEvents: .TouchUpInside)
        
        signUpButton = UIButton(frame: Constants.buttonFrame)
       // signUpButton.backgroundColor = UIColor.clearColor()
        signUpButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.layer.masksToBounds = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signUpButton)
        let signUpXConstraint = NSLayoutConstraint(item: signUpButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let signUpYConstraint = NSLayoutConstraint(item: signUpButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 100)
        self.view.addConstraint(signUpXConstraint)
        self.view.addConstraint(signUpYConstraint)
        signUpButton.addTarget(self, action: "showSignUpForDriver", forControlEvents: .TouchUpInside)

        // Do any additional setup after loading the view.
    }
    
    
    func showSignInForDriver() {
        let signInVC = DriverLoginViewController()
        signInVC.modalTransitionStyle = .CoverVertical
        presentViewController(signInVC, animated: true, completion: nil)
    }
    
    func showSignUpForDriver() {
        let signUpVC = DriverSignUpViewController()
        signUpVC.modalTransitionStyle = .CoverVertical
        presentViewController(signUpVC, animated: true, completion: nil)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
