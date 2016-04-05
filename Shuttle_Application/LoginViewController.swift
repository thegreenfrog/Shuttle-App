//
//  LoginViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 4/5/16.
//
//

import UIKit

class LoginViewController: UIViewController {

    override func performSegueWithIdentifier(identifier: String, sender: AnyObject?) {
        
        switch identifier {
        case "User Login":
            //presentViewController(userAuthController, animated: true, completion: nil)
            self.navigationController?.pushViewController(userAuthController, animated: true)
            
            print("hi")
            break
        default:
            print("this")
            break
        }
    }
    
    /*
    
    var destination = segue.destinationViewController
    
    if let navCon = destination as? UINavigationController{
    destination = navCon.visibleViewController!
    }
    if let destinationVC = destination as? CalculatorGraphViewController {
    let z = brain.program as? NSArray
    destinationVC.programVarFromVC = z
    destinationVC.vcDescription = brain.description
    }
    
    
    */
    
    let userAuthController = UserAuthViewController(nibName: "UserAuthViewController", bundle: nil)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        /*
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
        */
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func userLoginButton(sender: UIButton) {
        performSegueWithIdentifier(sender.titleLabel!.text!, sender: self )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: "LoginViewController", bundle: nibBundleOrNil)
        //return self
    }
    
    
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)
        
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
