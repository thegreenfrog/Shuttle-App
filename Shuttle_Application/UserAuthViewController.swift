//
//  UserAuthViewController.swift
//  Shuttle_Application
//
//  Created by James Boyle on 4/5/16.
//
//

import UIKit

class UserAuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func userLoggedIn(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
        if let _ = appDelegate {
            //segue to map

        }
     
    }
 }
