//
//  AppDelegate.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 2/28/16.
//
//

import UIKit

import Bolts
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var shouldNotBeDoingThis: String?

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        

        
        // Initialize Parse.
        Parse.enableLocalDatastore()
        Parse.setApplicationId("00zDxf1qjh6NBMJgkxO5DGaN81fEDksiDrsLB93P",
            clientKey: "LcamaCTndadV8ms6NbZz17FzfHJT0mRYZ4i1U130")
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //Enable Push Notifications
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey") {
            //immediately segue to map if user is signed in already
            if(NSUserDefaults.standardUserDefaults().boolForKey("isUser")) {
                //user
                
                

                
                
//                
//                let mapVC = MapViewController()
//                let navVC = UINavigationController(rootViewController: mapVC)
//                navVC.navigationBar.barTintColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
//                navVC.navigationBar.tintColor = UIColor.whiteColor()
//                navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//                
//                let settingsVC = UserSettingsTableViewController()
//                let settingsNavVC = UINavigationController(rootViewController: settingsVC)
//                
//                let sidebar = SWRevealViewController(rearViewController: settingsNavVC, frontViewController: navVC)
//                
//                
//                self.window?.rootViewController = sidebar
                
                
                //set up application
                let tabBarVC = UITabBarController()
                let mapVC = MapViewController()
                
                let mapNav = UINavigationController(rootViewController: mapVC)
                                mapNav.navigationBar.barTintColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
                                mapNav.navigationBar.tintColor = UIColor.whiteColor()
                                mapNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

                let listVC =  PickupLocationTableViewController() //UITableViewController()
                
                
                let listNav = UINavigationController(rootViewController: listVC)
                    listNav.navigationBar.barTintColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
                    listNav.navigationBar.tintColor = UIColor.whiteColor()
                    listNav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                
                
                 let controllers = [listNav, mapNav ]
                 tabBarVC.viewControllers = controllers
                 let mapImage = UIImage(named: "Map")
                 let listImage = UIImage(named: "List")
                 mapVC.tabBarItem = UITabBarItem(title: "Route", image: mapImage, tag: 1)
                 listVC.tabBarItem = UITabBarItem(title: "Queue", image: listImage, tag: 2)
                 self.window?.rootViewController = tabBarVC
                 //self.presentViewController(tabBarVC, animated: true, completion: nil)
 
            } else {
                //driver
                let navVC = UINavigationController()
                let mapVC = DriverMapViewController()
                navVC.viewControllers = [mapVC]
                navVC.navigationBar.barTintColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
                navVC.navigationBar.tintColor = UIColor.whiteColor()
                
                
                self.window?.rootViewController = navVC

            }
            
            
        } else {//show login page
            let welcomeVC = WelcomePageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
            self.window?.rootViewController = welcomeVC
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
    }
    
    func driverFound(notificationDictionary:[String: AnyObject]) {
        NSNotificationCenter.defaultCenter().postNotificationName("driverComing", object: nil)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let aps = userInfo["aps"] as! [String: AnyObject]
        driverFound(aps)
        PFPush.handlePush(userInfo)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return .Portrait
    }


}

