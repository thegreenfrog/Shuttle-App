//
//  SignInViewController.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 4/5/16.
//
//

import UIKit
import Parse

class UserSignUpViewController: UIViewController, UITextFieldDelegate {
    struct Constants {
        //error messages
        static let FirstNamePlaceHolder = "Please enter your first name"
        static let LastNamePlaceHolder = "Please enter your last name"
        static let EmailPlaceHolder = "Please enter your email address"
        static let PassPlaceHolder = "Please enter a password with at least 6 characters"
        static let RetypePassPlaceHolder = "Please re-enter the same password"
        
        static let EmailRegex = "[^@]+[@][a-z0-9]+[.][a-z]*"
    }
    
    let placeholders = ["First Name", "Last Name", "Username (email)", "Password", "Retype Password"]//textfield placeholders
    
    //input textfields
    var firstNameText: UITextField!
    var lastNameText: UITextField!
    var emailText: UITextField!
    var passText: UITextField!
    var retypePassText: UITextField!
    
    var modalListener: ModalUserTransitionListener?//instance of protocol to make callbacks to registerVC
    
    var signUpButton: UIButton!
    var exitButton: UIButton!
    
    //string array to hold all error messages
    var errorMessages = [String]()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        drawScreen()
        //dismisses keyboard when user taps outside of keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //helper function that draws all subviews necessary
    func drawScreen() {
        exitButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 75)))
        exitButton.setTitle("X", forState: .Normal)
        exitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exitButton.titleLabel!.font = UIFont.systemFontOfSize(24)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: "exitPage", forControlEvents: .TouchUpInside)
        
        firstNameText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        firstNameText.borderStyle = .Line
        firstNameText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        firstNameText.tag = 0
        firstNameText.font = UIFont.systemFontOfSize(24)
        firstNameText.returnKeyType = UIReturnKeyType.Done
        firstNameText.text = placeholders[firstNameText.tag]
        firstNameText.textColor = UIColor.lightGrayColor()
        firstNameText.delegate = self
        firstNameText.translatesAutoresizingMaskIntoConstraints = false
        
        lastNameText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        lastNameText.borderStyle = .Line
        lastNameText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        lastNameText.tag = 1
        lastNameText.font = UIFont.systemFontOfSize(24)
        lastNameText.returnKeyType = UIReturnKeyType.Done
        lastNameText.text = placeholders[lastNameText.tag]
        lastNameText.textColor = UIColor.lightGrayColor()
        lastNameText.delegate = self
        lastNameText.translatesAutoresizingMaskIntoConstraints = false
        
        emailText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        emailText.borderStyle = .Line
        emailText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        emailText.tag = 2
        emailText.font = UIFont.systemFontOfSize(24)
        emailText.returnKeyType = UIReturnKeyType.Done
        emailText.text = placeholders[emailText.tag]
        emailText.textColor = UIColor.lightGrayColor()
        emailText.delegate = self
        emailText.translatesAutoresizingMaskIntoConstraints = false
        
        passText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        passText.borderStyle = .Line
        passText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        passText.tag = 3
        passText.font = UIFont.systemFontOfSize(24)
        passText.returnKeyType = UIReturnKeyType.Done
        passText.text = placeholders[passText.tag]
        passText.textColor = UIColor.lightGrayColor()
        passText.delegate = self
        passText.translatesAutoresizingMaskIntoConstraints = false
        
        retypePassText = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 100)))
        retypePassText.borderStyle = .Line
        retypePassText.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        retypePassText.tag = 4
        retypePassText.font = UIFont.systemFontOfSize(24)
        retypePassText.returnKeyType = UIReturnKeyType.Done
        retypePassText.text = placeholders[retypePassText.tag]
        retypePassText.textColor = UIColor.lightGrayColor()
        retypePassText.delegate = self
        retypePassText.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 75)))
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.backgroundColor = UIColor.clearColor()
        signUpButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        signUpButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: "signUpAction", forControlEvents: .TouchUpInside)
        
        //put textfields in own stackview
        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(firstNameText)
        screenStackView.addArrangedSubview(lastNameText)
        screenStackView.addArrangedSubview(emailText)
        screenStackView.addArrangedSubview(passText)
        screenStackView.addArrangedSubview(retypePassText)
        //filler View used to create space between button and textfields
        let fillerView = UIView()
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        fillerView.heightAnchor.constraintEqualToConstant(20).active = true
        screenStackView.addArrangedSubview(fillerView)
        screenStackView.addArrangedSubview(signUpButton)
        screenStackView.alignment = .Fill
        screenStackView.axis = .Vertical
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenStackView)
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, constant: -25).active = true
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: -75).active = true
        
        self.view.addSubview(exitButton)
        exitButton.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 50).active = true
        exitButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -12).active = true
    }

    
    // MARK: - Signup
    
    //displays errors in input fields
    func handleErrors() {
        var allErrors = ""
        var first = true
        for error in errorMessages {
            if(!first) {
                allErrors += "\n"
            }
            allErrors += error
            first = false
        }
        let alert = UIAlertController(title: nil, message: allErrors, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
        errorMessages = []
    }
    
    //check all textfields for correct input
    func checkForErrors() {
        if firstNameText.textColor == UIColor.lightGrayColor() {//make sure there is something in the textfield
            errorMessages.append(Constants.FirstNamePlaceHolder)
            return
        }
        if lastNameText.textColor == UIColor.lightGrayColor() {//make sure there is something in the textfield
            errorMessages.append(Constants.LastNamePlaceHolder)
            return
        }
        if emailText.textColor == UIColor.lightGrayColor() || emailText.text?.rangeOfString(Constants.EmailRegex, options: .RegularExpressionSearch) == nil {//make sure textfield has input, email fit email regex template
            errorMessages.append(Constants.EmailPlaceHolder)
            return
        }
        if passText.textColor == UIColor.lightGrayColor() || passText.text!.characters.count < 6 {//make sure textfield has input and password is at least 6 characters/numbers
            errorMessages.append(Constants.PassPlaceHolder)
            return
        }
        if passText.textColor == UIColor.lightGrayColor() || retypePassText.text!.characters.count != passText.text!.characters.count {//check textfield has input and equals password input in other textfield
            errorMessages.append(Constants.RetypePassPlaceHolder)
            return
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
            let user = PFUser()
            user.username = emailText.text
            user.email = emailText.text
            user.password = passText.text
            user["firstName"] = firstNameText.text
            user["lastName"] = lastNameText.text
            user.setValue(true, forKey: "isUser")
            user.signUpInBackgroundWithBlock({
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    if let errorString = error.userInfo["error"] as? NSString {
                        self.errorMessages.append(errorString as String)
                    }
                    self.handleErrors()
                } else {
                    //save user info in NSUserDefaults
                    let keyChainWrapper = KeychainWrapper()
                    keyChainWrapper.mySetObject(self.passText.text, forKey: kSecValueData)
                    keyChainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().setValue(self.emailText.text, forKey: "username")
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUser")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    //exit modalView to transition to main app
                    self.modalListener?.returnFromModal(true)
                    self.dismissViewControllerAnimated(true, completion: {
                        self.modalListener?.goToApp()
                    })
                }
            })
        }
        
    }

    // MARK: - TextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.textColor == UIColor.lightGrayColor() {
            textField.text = nil
            textField.textColor = UIColor.whiteColor()
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
    
    //exit modal screen back to register page
    func exitPage() {
        modalListener?.returnFromModal(false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
