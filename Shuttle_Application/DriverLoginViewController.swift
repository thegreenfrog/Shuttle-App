//
//  DriverLoginViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 4/17/16.
//
//

import UIKit
import Parse
import Bolts


class DriverLoginViewController: UIViewController, UITextFieldDelegate {

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
    var exitButton: UIButton!
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    
    var modalListener: ModalDriverTransitionListener?//instance for protocol to handle returning to registerVC
    
    let placeholders = ["Username (email)", "Password"]//placeholders for textfields
    
    var errorMessages = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        drawScreen()
        
        //keyboard disappears whenever user taps somewhere else other than keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
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
        signInButton.addTarget(self, action: "driverSignInAction", forControlEvents: .TouchUpInside)
        
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
    func driverSignInAction() {
        self.modalListener?.returnFromModal(true)
        self.dismissViewControllerAnimated(true, completion: {
            self.modalListener?.goToApp()
        })
        return
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
    */
    

}
