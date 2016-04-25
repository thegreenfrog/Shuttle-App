//
//  WelcomePageViewController.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 4/20/16.
//
//

import UIKit


class WelcomePageViewController: UIPageViewController {

    //array that holds all VCs that user can swipe between
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController("DriverRegister"),
            self.newColoredViewController("Welcome"),
            self.newColoredViewController("UserRegister")]
    }()
    
    private func newColoredViewController(name: String) -> UIViewController {
        switch name {
        case "UserRegister":
            return UserRegisterViewController()
        case "Welcome":
            return WelcomeViewController()
        case "DriverRegister":
            return DriverRegisterViewController()
        default:
            return UIViewController()
        }
    }
    
    // MARK: - LifeCycle
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let middleViewController = orderedViewControllers[1]//set starting VC
        setViewControllers([middleViewController], direction: .Forward, animated: true, completion: nil)
        
        //set background image depending on device
        let backgroundView = UIImageView(frame: self.view.bounds)
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            backgroundView.image = UIImage(named: "car-door-iphone.jpg")
        } else {
            backgroundView.image = UIImage(named: "car-door-ipad.jpg")
        }
        backgroundView.contentMode = .ScaleAspectFill
        self.view.addSubview(backgroundView)
        self.view.sendSubviewToBack(backgroundView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


/*
    PageVC delegate methods to switch between VCs
*/
extension WelcomePageViewController: UIPageViewControllerDataSource {
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            
            guard orderedViewControllers.count > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
}
