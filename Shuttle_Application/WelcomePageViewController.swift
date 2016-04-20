//
//  WelcomePageViewController.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 4/20/16.
//
//

import UIKit

class WelcomePageViewController: UIPageViewController {

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
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : AnyObject]?) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        //allows for custom setting of transition
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let middleViewController = orderedViewControllers[1]
        setViewControllers([middleViewController], direction: .Forward, animated: true, completion: nil)
        
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

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

//copied from http://digitalleaves.com/blog/2015/07/bezier-paths-in-practice-i-from-basic-shapes-to-custom-designable-controls/
extension UIImage {
    class func shapeImageWithBezierPath(bezierPath: UIBezierPath, fillColor: UIColor?, strokeColor: UIColor?, strokeWidth: CGFloat = 0.0) -> UIImage! {
        //Normalize bezier path. We will apply a transform to our bezier path to ensure that it's placed at the coordinate axis. Then we can get its size.
        bezierPath.applyTransform(CGAffineTransformMakeTranslation(-bezierPath.bounds.origin.x, -bezierPath.bounds.origin.y))
        let size = CGSizeMake(bezierPath.bounds.size.width, bezierPath.bounds.size.height)
        
        //Initialize an image context with our bezier path normalized shape and save current context
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        //Set path
        CGContextAddPath(context, bezierPath.CGPath)
        
        //Set parameters and draw
        if strokeColor != nil {
            strokeColor!.setStroke()
            CGContextSetLineWidth(context, strokeWidth)
        } else { UIColor.clearColor().setStroke() }
        fillColor?.setFill()
        
        CGContextDrawPath(context, .FillStroke)
        //Get the image from the current image context
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //Restore context and close everything
        CGContextRestoreGState(context)
        UIGraphicsEndImageContext()
        
        return image
    }

}
