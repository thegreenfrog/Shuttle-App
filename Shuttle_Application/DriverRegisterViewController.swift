//
//  DriverRegisterViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 4/7/16.
//
//

import UIKit

protocol ModalDriverTransitionListener {
    func returnFromModal(registered: Bool)
    func goToApp()
}

class DriverRegisterViewController: UIViewController, ModalDriverTransitionListener, UIViewControllerTransitioningDelegate {

    struct Constants {
    static let buttonFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 45))
    static let labelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 225, height: 100))
    }
    
    var signInButton: UIButton!
    var signUpButton: UIButton!
    
    let transition = VCAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        
        signInButton = UIButton(frame: Constants.buttonFrame)
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        signInButton.layer.borderWidth = 1.0
        signInButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.layer.masksToBounds = true
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: "showSignInForDriver", forControlEvents: .TouchUpInside)
        
        signUpButton = UIButton(frame: Constants.buttonFrame)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.layer.masksToBounds = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: "showSignUpForDriver", forControlEvents: .TouchUpInside)

        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(signInButton)
        screenStackView.addArrangedSubview(signUpButton)
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Fill
        screenStackView.spacing = 10
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenStackView)
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: 25).active = true
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.5).active = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        signInButton.hidden = false
        signUpButton.hidden = false
    }
    
    func showSignInForDriver() {
        let signInVC = DriverLoginViewController()
        signInVC.modalTransitionStyle = .CoverVertical
        signInVC.modalPresentationStyle = .OverCurrentContext
        signInVC.modalListener = self   // CH
        signInButton.hidden = true
        signUpButton.hidden = true
        presentViewController(signInVC, animated: true, completion: nil)
    }
    
    func showSignUpForDriver() {
        let signUpVC = DriverSignUpViewController()
        signUpVC.modalTransitionStyle = .CoverVertical
        signUpVC.modalPresentationStyle = .OverCurrentContext
        signUpVC.modalListener = self //CH
        signInButton.hidden = true
        signUpButton.hidden = true
        presentViewController(signUpVC, animated: true, completion: nil)
    }
    
    func returnFromModal(registered: Bool) {
        if(registered) {
            //show spinning wheel
            let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            loadingIndicator.userInteractionEnabled = false
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicator.startAnimating()
            self.view.addSubview(loadingIndicator)
            loadingIndicator.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
            loadingIndicator.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
            
            
        } else {
            signInButton.hidden = false
            signUpButton.hidden = false
        }
        
    }
    
    func goToApp() {
        //seque to main application
        
        
        let mapVC = DriverMapViewController()
        mapVC.title = "Uber Driver Bowdoin"
        let navVC = UINavigationController()
        navVC.viewControllers = [mapVC]
        navVC.navigationBar.barTintColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        navVC.navigationBar.tintColor = UIColor.whiteColor()
        
        mapVC.transitioningDelegate = self
        self.presentViewController(navVC, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

/*
delegate function that indicates which transition animator to use
*/
extension DriverRegisterViewController {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            return transition
    }
}
