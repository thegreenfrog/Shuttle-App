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
        
        static let textFieldFrame:CGRect = CGRect(origin: CGPointZero, size: CGSize(width: 0, height: 0))
    }
    
    //buttons and textfield variables
    var signInButton: UIButton!
    var exitButton: UIButton!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    var modalListener: ModalUserTransitionListener?//instance for protocol to handle returning to registerVC
    
    let placeholders = ["Username (email)", "Password"]//placeholders for textfields
    
    var errorMessages = [String]()//holds all error messages, though right now app just displays one error at a time
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        drawScreen()
        
        //keyboard disappears whenever user taps somewhere else other than keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //helper function to draw all subviews necessary
    func drawScreen() {
        exitButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: 75, height: 75)))
        exitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        exitButton.titleLabel!.font = UIFont.systemFontOfSize(24)
        exitButton.setTitle("X", forState: .Normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.addTarget(self, action: "exitPage", forControlEvents: .TouchUpInside)
        
        emailTextField = UITextField(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width-10, height: 100)))
        emailTextField.borderStyle = .Line
        emailTextField.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        emailTextField.tag = 0
        emailTextField.font = UIFont.systemFontOfSize(24)
        emailTextField.returnKeyType = UIReturnKeyType.Done
        emailTextField.text = placeholders[emailTextField.tag]
        emailTextField.textColor = UIColor.lightGrayColor()
        emailTextField.delegate = self
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField = UITextField(frame: CGRectMake(0, 0, self.view.frame.width-10, 75))
        passwordTextField.borderStyle = .Line
        passwordTextField.backgroundColor = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 0.8)
        passwordTextField.tag = 1
        passwordTextField.font = UIFont.systemFontOfSize(24)
        passwordTextField.returnKeyType = UIReturnKeyType.Done
        passwordTextField.text = placeholders[passwordTextField.tag]
        passwordTextField.textColor = UIColor.lightGrayColor()
        passwordTextField.delegate = self
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: 75)))
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signInButton.titleLabel?.font = UIFont.systemFontOfSize(24)
        signInButton.backgroundColor = UIColor.clearColor()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: "signInAction", forControlEvents: .TouchUpInside)
        
        let screenStackView = UIStackView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.view.frame.width, height: self.view.frame.height)))
        screenStackView.addArrangedSubview(emailTextField)
        screenStackView.addArrangedSubview(passwordTextField)
        let fillerView = UIView()
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        fillerView.heightAnchor.constraintEqualToConstant(20).active = true
        screenStackView.addArrangedSubview(fillerView)
        screenStackView.addArrangedSubview(signInButton)
        screenStackView.axis = .Vertical
        screenStackView.alignment = .Fill
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenStackView)
        
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, constant: -25).active = true
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: -75).active = true
        
        self.view.addSubview(exitButton)
        exitButton.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 50).active = true
        exitButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -12).active = true
        
    }
    
    
    // MARK: - Login
    
    func checkForErrors() {
        if emailTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoEmail)
            return
        } else if passwordTextField.textColor == UIColor.lightGrayColor() {
            errorMessages.append(Constants.NoPassword)
            return
        }
    }
    
    
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
    
    //action called when user taps "Sign In"
    func signInAction() {
//        self.modalListener?.returnFromModal(true)
//        self.dismissViewControllerAnimated(true, completion: {
//            self.modalListener?.goToApp()
//        })
//        return
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
                    self.modalListener?.returnFromModal(true)
                    self.dismissViewControllerAnimated(true, completion: {
                        self.modalListener?.goToApp()
                    })
                    
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
    
    //exit modal screen back to Register VC
    func exitPage() {
        modalListener?.returnFromModal(false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - TextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.textColor == UIColor.lightGrayColor() {
            textField.text = nil
            textField.textColor = UIColor.whiteColor()
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

}
