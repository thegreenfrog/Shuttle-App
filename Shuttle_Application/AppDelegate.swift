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
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("00zDxf1qjh6NBMJgkxO5DGaN81fEDksiDrsLB93P",
            clientKey: "LcamaCTndadV8ms6NbZz17FzfHJT0mRYZ4i1U130")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let logInVC = RegisterViewController()
        //let navigationController = UINavigationController(rootViewController: vc) ask me about this sometime
        self.window?.rootViewController = logInVC
        
//        let tabBarController = RequestTabBarController()
//        let mapVC = MapViewController(nibName: "MapViewController", bundle: nil)
//        let listVC = RequestTableViewController(nibName: "RequestTableViewController", bundle: nil)
//        let controllers = [mapVC, listVC]
//        tabBarController.viewControllers = controllers
//        let mapImage = UIImage(named: "Map")
//        let listImage = UIImage(named: "List")
//        mapVC.tabBarItem = UITabBarItem(title: "Route", image: mapImage, tag: 1)
//        listVC.tabBarItem = UITabBarItem(title: "Queue", image: listImage, tag: 2)
        
        return true
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

