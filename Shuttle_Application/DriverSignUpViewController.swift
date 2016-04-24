//
//  DriverSignUpViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 4/17/16.
//
//

import UIKit
import Parse

class DriverSignUpViewController: UIViewController, UITextFieldDelegate {
    struct Constants {
        static let FirstNamePlaceHolder = "Please enter your first name"
        static let LastNamePlaceHolder = "Please enter your last name"
        static let EmailPlaceHolder = "Please enter your email address"
        static let PassPlaceHolder = "Please enter a password with at least 6 characters"
        static let RetypePassPlaceHolder = "Please re-enter the same password"
        
        static let EmailRegex = "[^@]+[@][a-z0-9]+[.][a-z]*"
        
        static let ErrorBorderWidth:CGFloat = 1.0
        static let ErrorMessageProportionHeight:CGFloat = 20.0
        static let ErrorMessageWidth:CGFloat = 200.0
    }
    
    let placeholders = ["First Name", "Last Name", "Username (email)", "Password", "Retype Password"]
    //There needs to be a way of determining whether or not someone is or can be a driver.
    
    
    //input textfields
    var firstNameText: UITextField!
    var lastNameText: UITextField!
    var emailText: UITextField!
    var passText: UITextField!
    var retypePassText: UITextField!
    var exitButton: UIButton!
    
    var modalListener: ModalDriverTransitionListener?//instance of protocol to make callbacks to registerVC
    
    var signUpButton: UIButton!
    
    //string array to hold all error messages
    var errorMessages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 75)))
        exitButton.setTitle("X", forState: .Normal)
        exitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exitButton.titleLabel!.font = UIFont.systemFontOfSize(24)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: "exitPage", forControlEvents: .TouchUpInside)

        //create all textfields, buttons, and their constraints
        firstNameText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        firstNameText.borderStyle = .Line
        firstNameText.tag = 0
        firstNameText.font = UIFont.systemFontOfSize(30)
        firstNameText.returnKeyType = UIReturnKeyType.Done
        firstNameText.text = placeholders[firstNameText.tag]
        firstNameText.textColor = UIColor.lightGrayColor()
        firstNameText.delegate = self
        firstNameText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(firstNameText)
        let firstNameCenterXConstraint = NSLayoutConstraint(item: firstNameText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let firstNameLeftConstraint = NSLayoutConstraint(item: firstNameText, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let firstNameCenterYContraint = NSLayoutConstraint(item: firstNameText, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -200)
        self.view.addConstraint(firstNameCenterXConstraint)
        self.view.addConstraint(firstNameCenterYContraint)
        self.view.addConstraint(firstNameLeftConstraint)
        
        lastNameText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        lastNameText.borderStyle = .Line
        lastNameText.tag = 1
        lastNameText.font = UIFont.systemFontOfSize(30)
        lastNameText.returnKeyType = UIReturnKeyType.Done
        lastNameText.text = placeholders[lastNameText.tag]
        lastNameText.textColor = UIColor.lightGrayColor()
        lastNameText.delegate = self
        lastNameText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lastNameText)
        let lastNameCenterXConstraint = NSLayoutConstraint(item: lastNameText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let lastNameLeftConstraint = NSLayoutConstraint(item: lastNameText, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let lastNameCenterYContraint = NSLayoutConstraint(item: lastNameText, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -150)
        self.view.addConstraint(lastNameCenterXConstraint)
        self.view.addConstraint(lastNameCenterYContraint)
        self.view.addConstraint(lastNameLeftConstraint)
        
        emailText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        emailText.borderStyle = .Line
        emailText.tag = 2
        emailText.font = UIFont.systemFontOfSize(30)
        emailText.returnKeyType = UIReturnKeyType.Done
        emailText.text = placeholders[emailText.tag]
        emailText.textColor = UIColor.lightGrayColor()
        emailText.delegate = self
        emailText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(emailText)
        let emailCenterXConstraint = NSLayoutConstraint(item: emailText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let emailLeftConstraint = NSLayoutConstraint(item: emailText, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let emailCenterYContraint = NSLayoutConstraint(item: emailText, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -100)
        self.view.addConstraint(emailCenterXConstraint)
        self.view.addConstraint(emailCenterYContraint)
        self.view.addConstraint(emailLeftConstraint)
        
        passText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        passText.borderStyle = .Line
        passText.tag = 3
        passText.font = UIFont.systemFontOfSize(30)
        passText.returnKeyType = UIReturnKeyType.Done
        passText.text = placeholders[passText.tag]
        passText.textColor = UIColor.lightGrayColor()
        passText.delegate = self
        passText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(passText)
        let passCenterXConstraint = NSLayoutConstraint(item: passText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let passLeftConstraint = NSLayoutConstraint(item: passText, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let passCenterYContraint = NSLayoutConstraint(item: passText, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: -50)
        self.view.addConstraint(passCenterXConstraint)
        self.view.addConstraint(passCenterYContraint)
        self.view.addConstraint(passLeftConstraint)
        
        retypePassText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        retypePassText.borderStyle = .Line
        retypePassText.tag = 4
        retypePassText.font = UIFont.systemFontOfSize(30)
        retypePassText.returnKeyType = UIReturnKeyType.Done
        retypePassText.text = placeholders[retypePassText.tag]
        retypePassText.textColor = UIColor.lightGrayColor()
        retypePassText.delegate = self
        retypePassText.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(retypePassText)
        let retypeCenterXConstraint = NSLayoutConstraint(item: retypePassText, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let retypeLeftConstraint = NSLayoutConstraint(item: retypePassText, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let retypeCenterYContraint = NSLayoutConstraint(item: retypePassText, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(retypeCenterXConstraint)
        self.view.addConstraint(retypeCenterYContraint)
        self.view.addConstraint(retypeLeftConstraint)
        
        signUpButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 75)))
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.backgroundColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signUpButton)
        let signUpCenterXConstraint = NSLayoutConstraint(item: signUpButton, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let signUpLeftConstraint = NSLayoutConstraint(item: signUpButton, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 10)
        let signUpCenterYContraint = NSLayoutConstraint(item: signUpButton, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 50)
        self.view.addConstraint(signUpCenterXConstraint)
        self.view.addConstraint(signUpCenterYContraint)
        self.view.addConstraint(signUpLeftConstraint)
        signUpButton.addTarget(self, action: "signUpAction", forControlEvents: .TouchUpInside)
        
        //dismisses keyboard when user taps outside of keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //highlights the improperly input fields in red
    func highlightTextField(textField: UITextField) {
        textField.layer.borderWidth = Constants.ErrorBorderWidth
        textField.layer.borderColor = UIColor.redColor().CGColor
    }
    
    //displays errors in input fields
    func handleErrors() {
        let frame = CGRect(origin: CGPointZero, size: CGSize(width: Constants.ErrorMessageWidth, height: Constants.ErrorMessageProportionHeight * CGFloat(errorMessages.count)))
        let errorSubView = UIView(frame: frame)
        errorSubView.center.x = signUpButton.center.x
        errorSubView.center.y = signUpButton.center.y + Constants.ErrorMessageProportionHeight * CGFloat(errorMessages.count)
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
    
    //check all textfields for correct input
    func checkForErrors() {
        if firstNameText.textColor == UIColor.lightGrayColor() {//make sure there is something in the textfield
            errorMessages.append(Constants.FirstNamePlaceHolder)
            highlightTextField(firstNameText)
        }
        if lastNameText.textColor == UIColor.lightGrayColor() {//make sure there is something in the textfield
            errorMessages.append(Constants.LastNamePlaceHolder)
            highlightTextField(lastNameText)
        }
        if emailText.textColor == UIColor.lightGrayColor() || emailText.text?.rangeOfString(Constants.EmailRegex, options: .RegularExpressionSearch) == nil {//make sure textfield has input, email fit email regex template
            errorMessages.append(Constants.EmailPlaceHolder)
            highlightTextField(emailText)
        }
        if passText.textColor == UIColor.lightGrayColor() || passText.text!.characters.count < 6 {//make sure textfield has input and password is at least 6 characters/numbers
            errorMessages.append(Constants.PassPlaceHolder)
            highlightTextField(passText)
        }
        if passText.textColor == UIColor.lightGrayColor() || retypePassText.text!.characters.count != passText.text!.characters.count {//check textfield has input and equals password input in other textfield
            errorMessages.append(Constants.RetypePassPlaceHolder)
            highlightTextField(passText)
        }
    }
    
    //function called when user taps "Sign Up"
    func signUpAction() {
        //make sure inputs are filled in properly
        checkForErrors()
        
        //submit user or post error message
        if errorMessages.count > 0 {
            handleErrors()
        } else {
            //attempt to log in
            let driver = PFUser()
            driver.username = emailText.text
            driver.email = emailText.text
            driver.password = passText.text
            driver["firstName"] = firstNameText.text
            driver["lastName"] = lastNameText.text
            driver.signUpInBackgroundWithBlock({
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    if let errorString = error.userInfo["error"] as? NSString {
                        self.errorMessages.append(errorString as String)
                    }
                    self.handleErrors()
                } else {
                    //save user info
                    let keyChainWrapper = KeychainWrapper()
                    keyChainWrapper.mySetObject(self.passText.text, forKey: kSecValueData)
                    keyChainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().setValue(self.emailText.text, forKey: "username")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.modalListener?.returnFromModal(true)
                    self.dismissViewControllerAnimated(true, completion: {
                        self.modalListener?.goToApp()
                    })
                    
                    /*
                    //set up application
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
                    */
                }
            })
        }
        
    }
    
    // MARK: - TextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.textColor == UIColor.lightGrayColor() {
            textField.text = nil
            textField.textColor = UIColor.blackColor()
            if textField.tag == 3 || textField.tag == 4 {
                textField.secureTextEntry = true
            }
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text!.isEmpty {
            if textField.tag == 3 || textField.tag == 4 {
                textField.secureTextEntry = false
            }
            textField.textColor = UIColor.lightGrayColor()
            textField.text = placeholders[textField.tag]
        }
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func exitPage() {
        modalListener?.returnFromModal(false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */}
