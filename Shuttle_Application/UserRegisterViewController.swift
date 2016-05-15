//
//  RegisterViewController.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 4/5/16.
//
//

import UIKit

protocol ModalUserTransitionListener {
    func returnFromModal(registered: Bool)
    func goToApp()
}

class UserRegisterViewController: UIViewController, ModalUserTransitionListener, UIViewControllerTransitioningDelegate {
    struct Constants {
        static let buttonFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 45))
        static let labelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 225, height: 100))
    }
    
    let transition = VCAnimator()
    
    var signInButton: UIButton!
    var signUpButton: UIButton!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawScreen()
        self.view.backgroundColor = UIColor.clearColor()//allows background image to show
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //creates buttons for screen
    func drawScreen() {
        signInButton = UIButton(frame: Constants.buttonFrame)
        signInButton.backgroundColor = UIColor.clearColor()
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        signInButton.layer.borderColor = UIColor.whiteColor().CGColor
        signInButton.layer.borderWidth = 1.0
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.layer.masksToBounds = true
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: "showSignIn", forControlEvents: .TouchUpInside)
        
        signUpButton = UIButton(frame: Constants.buttonFrame)
        signUpButton.backgroundColor = UIColor.clearColor()
        signUpButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.layer.masksToBounds = true
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: "showSignUp", forControlEvents: .TouchUpInside)
        
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
    }
    
    // MARK: - Button Actions
    
    func showSignIn() {
        let signInVC = UserLoginViewController()
        signInVC.modalTransitionStyle = .CoverVertical
        signInVC.modalPresentationStyle = .OverCurrentContext
        signInVC.modalListener = self
        signInButton.hidden = true
        signUpButton.hidden = true
        presentViewController(signInVC, animated: true, completion: nil)
    }
    
    func showSignUp() {
        let signUpVC = UserSignUpViewController()
        signUpVC.modalTransitionStyle = .CoverVertical
        signUpVC.modalPresentationStyle = .OverCurrentContext
        signUpVC.modalListener = self
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
        let mapVC = MapViewController()
        let navVC = UINavigationController()
        navVC.viewControllers = [mapVC]
        navVC.navigationBar.barTintColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        navVC.navigationBar.tintColor = UIColor.whiteColor()
        navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navVC.transitioningDelegate = self//allows for custom transition
        self.presentViewController(navVC, animated: true, completion: nil)
        
    }

}

/*
    delegate function that indicates which transition animator to use
*/
extension UserRegisterViewController {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            return transition
    }
}

