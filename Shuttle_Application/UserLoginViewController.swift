//
//  LoginViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 4/5/16.
//
//

import UIKit
import Parse
import Bolts

class UserLoginViewController: UIViewController, UITextFieldDelegate {
    
    struct Constants {
        static let NoEmail = "Please enter your username"
        static let NoPassword = "Please enter your password"
        
        static let ErrorBorderWidth:CGFloat = 1.0
        static let ErrorMessageProportionHeight:CGFloat = 20.0
        static let ErrorMessageWidth:CGFloat = 200.0
        
        static let textFieldFrame:CGRect = CGRect(origin: CGPointZero, size: CGSize(width: 0, height: 0))
    }
    
    //buttons and textfield variables
    var signInButton: UIButton!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    let placeholders = ["Username (email)", "Password"]//placeholders for textfields
    
    var errorMessages = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            print("Object has been saved.")
//        }
        
        
        //create the loginbutton, email and password input textfields, and their constraints programtically
        emailTextField = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        emailTextField.borderStyle = .Line
        emailTextField.tag = 0
        emailTextField.font = UIFont.systemFontOfSize(30)
        emailTextField.returnKeyType = UIReturnKeyType.Done
        emailTextField.text = placeholders[emailTextField.tag]
        emailTextField.textColor = UIColor.lightGrayColor()
        emailTextField.delegate = self
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailTextField)
        let emailCenterXConstraint = NSLayoutConstraint(item: emailTextField, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let emailLeftConstraint = NSLayoutConstraint(item: emailTextField, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let emailCenterYContraint = NSLayoutConstraint(item: emailTextField, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -100)
        self.view.addConstraint(emailCenterYContraint)
        self.view.addConstraint(emailCenterXConstraint)
        self.view.addConstraint(emailLeftConstraint)
        
        passwordTextField = UITextField(frame: CGRectMake(0, 0, self.view.frame.width-10, 75))
        passwordTextField.borderStyle = .Line
        passwordTextField.tag = 1
        passwordTextField.font = UIFont.systemFontOfSize(30)
        passwordTextField.returnKeyType = UIReturnKeyType.Done
        passwordTextField.text = placeholders[passwordTextField.tag]
        passwordTextField.textColor = UIColor.lightGrayColor()
        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passwordTextField)
        let passwordCenterXConstraint = NSLayoutConstraint(item: passwordTextField, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let passwordLeftConstraint = NSLayoutConstraint(item: passwordTextField, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let passwordCenterYContraint = NSLayoutConstraint(item: passwordTextField, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -50)
        self.view.addConstraint(passwordCenterXConstraint)
        self.view.addConstraint(passwordCenterYContraint)
        self.view.addConstraint(passwordLeftConstraint)
        
        signInButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 75)))
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        let signInCenterXConstraint = NSLayoutConstraint(item: signInButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let signInLeftConstraint = NSLayoutConstraint(item: signInButton, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let signInCenterYContraint = NSLayoutConstraint(item: signInButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(signInCenterXConstraint)
        self.view.addConstraint(signInCenterYContraint)
        self.view.addConstraint(signInLeftConstraint)
        signInButton.addTarget(self, action: "signInAction", forControlEvents: .TouchUpInside)
        
        //keyboard disappears whenever user taps somewhere else other than keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func checkForErrors() {
        if emailTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoEmail)
            emailTextField.layer.borderColor = UIColor.redColor().CGColor
            emailTextField.layer.borderWidth = Constants.ErrorBorderWidth
        } else if passwordTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoPassword)
            passwordTextField.layer.borderColor = UIColor.redColor().CGColor
            passwordTextField.layer.borderWidth = Constants.ErrorBorderWidth
        }
    }
    
    func handleErrors() {
        emailTextField.layer.borderWidth = 0.0
        passwordTextField.layer.borderWidth = 0.0
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: Constants.ErrorMessageWidth, height: Constants.ErrorMessageProportionHeight * CGFloat(errorMessages.count)))
        let errorSubView = UIView(frame: frame)
        errorSubView.center.x = signInButton.center.x
        errorSubView.center.y = signInButton.center.y + Constants.ErrorMessageProportionHeight * CGFloat(errorMessages.count)
        errorSubView.layer.borderColor = UIColor.redColor().CGColor
        errorSubView.layer.borderWidth = Constants.ErrorBorderWidth
        var count = 0
        for error in errorMessages {
            let labelOrigin = CGPoint(x: errorSubView.layer.bounds.origin.x, y: errorSubView.layer.bounds.origin.y + Constants.ErrorMessageProportionHeight * CGFloat(count))
            let errorFrame = CGRect(origin: labelOrigin, size: CGSize(width: Constants.ErrorMessageWidth, height: Constants.ErrorMessageProportionHeight))
            let label = UILabel(frame: errorFrame)
            label.text = error
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.font = UIFont(name: label.font.fontName, size: 10)
            errorSubView.addSubview(label)
            count++
        }
        self.view.addSubview(errorSubView)
    }
    
    //action called when user taps "Sign In"
    func signInAction() {
        checkForErrors()//check for improper inputs
        
        if(errorMessages.count > 0) {//show error messages if improper inputs exist
            handleErrors()
        } else {//attempt to log in
            PFUser.logInWithUsernameInBackground(emailTextField.text!, password: passwordTextField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    //save user info
                    let keyChainWrapper = KeychainWrapper()
                    keyChainWrapper.mySetObject(self.passwordTextField.text, forKey: kSecValueData)
                    keyChainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().setValue(self.emailTextField.text, forKey: "username")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    //seque to main application
                    let tabBarVC = UITabBarController()
                    let mapVC = MapViewController(nibName: "MapViewController", bundle: nil)
                    let listVC = RequestTableViewController(nibName: "RequestTableViewController", bundle: nil)
                    let controllers = [mapVC, listVC]
                    tabBarVC.viewControllers = controllers
                    let mapImage = UIImage(named: "Map")
                    let listImage = UIImage(named: "List")
                    mapVC.tabBarItem = UITabBarItem(title: "Route", image: mapImage, tag: 1)
                    listVC.tabBarItem = UITabBarItem(title: "Queue", image: listImage, tag: 2)
                    
                    self.presentViewController(tabBarVC, animated: true, completion: nil)
                } else {
                    // The login failed
                    if let error = error {
                        self.errorMessages.append(error.localizedDescription)
                        self.handleErrors()
                    }
                }
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.textColor == UIColor.lightGrayColor() {
            textField.text = nil
            textField.textColor = UIColor.blackColor()
            if textField.tag == 1 {
                textField.secureTextEntry = true
            }
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text!.isEmpty {
            if textField.tag == 1 {
                textField.secureTextEntry = false
            }
            textField.text = placeholders[textField.tag]
            textField.textColor = UIColor.lightGrayColor()
        }
        textField.resignFirstResponder()
    }
    
    //Causes the view (or one of its embedded text fields) to resign the first responder status.
    func dismissKeyboard() {
        view.endEditing(true)
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
