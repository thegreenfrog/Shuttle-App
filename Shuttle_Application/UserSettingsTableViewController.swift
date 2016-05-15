//
//  UserSettingsTableViewController.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 5/15/16.
//
//

import UIKit
import Parse

class UserSettingsTableViewController: UITableViewController, UIViewControllerTransitioningDelegate {
    
    let options = ["Sign Out"]
    
    let transition = VCAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        }
        cell!.textLabel!.text = options[indexPath.row]
        return cell!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            case 0:
                signOut()
                return
            default:
                return
        }
    }
    
    //helper function that is called when user wants to sign out
    func signOut() {
        //save user info in NSUserDefaults

        PFUser.logOutInBackgroundWithBlock({ (err) -> Void in
            if err != nil {
                let alert = UIAlertController(title: "Error", message: "\(err)", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            self.revealViewController().revealToggle(nil)
            let keyChainWrapper = KeychainWrapper()
            keyChainWrapper.mySetObject(nil, forKey: kSecValueData)
            keyChainWrapper.writeToKeychain()
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoginKey")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("username")
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUser")
            
            let welcomeVC = WelcomePageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
            welcomeVC.transitioningDelegate = self
            self.presentViewController(welcomeVC, animated: true, completion: nil)
        })
        
    }

}

/*
delegate function that indicates which transition animator to use
*/
extension UserSettingsTableViewController {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            return transition
    }
}
