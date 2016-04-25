//
//  WelcomeViewController.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 4/6/16.
//
//

import UIKit
import Parse

class WelcomeViewController: UIViewController {

    struct Constants {
        static let buttonFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 200, height: 45))
        static let labelFrame:CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 225, height: 100))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        drawScreen()
        
    }
    
    func drawScreen() {
        let welcomeLabel = UILabel(frame: Constants.labelFrame)
        welcomeLabel.textColor = UIColor.whiteColor()
        welcomeLabel.numberOfLines = 0
        welcomeLabel.text = "Welcome!"
        welcomeLabel.textAlignment = .Center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let driverlabel = UILabel(frame: Constants.buttonFrame)
        driverlabel.font = UIFont.systemFontOfSize(14)
        driverlabel.text = "Driver?\nSwipe Left!"
        driverlabel.textColor = UIColor.whiteColor()
        driverlabel.numberOfLines = 0
        driverlabel.lineBreakMode = .ByWordWrapping
        driverlabel.textAlignment = .Left
        driverlabel.translatesAutoresizingMaskIntoConstraints = false
        let rightArrowPath = UIBezierPath()
        var start = CGPointZero
        rightArrowPath.moveToPoint(start)
        var next = CGPoint(x: start.x+25, y: start.y-20)
        rightArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x, y: next.y+10)
        rightArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x+50, y: next.y)
        rightArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x, y: next.y+20)
        rightArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x-50, y: next.y)
        rightArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x, y: next.y+10)
        rightArrowPath.addLineToPoint(next)
        rightArrowPath.addLineToPoint(start)
        rightArrowPath.closePath()
        let rightArrowShape = UIImage.shapeImageWithBezierPath(rightArrowPath, fillColor: UIColor.clearColor(), strokeColor: UIColor.whiteColor(), strokeWidth: 1.0)
        let rightImageView = UIImageView(image: rightArrowShape)
        let driverlabelStackView = UIStackView()
        driverlabelStackView.addArrangedSubview(driverlabel)
        driverlabelStackView.addArrangedSubview(rightImageView)
        driverlabelStackView.axis = .Vertical
        driverlabelStackView.spacing = 10
        driverlabelStackView.distribution = .EqualSpacing
        driverlabelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let consumerLabel = UILabel(frame: Constants.buttonFrame)
        consumerLabel.font = UIFont.systemFontOfSize(14)
        consumerLabel.text = "User?\nSwipe Right!"
        consumerLabel.textColor = UIColor.whiteColor()
        consumerLabel.numberOfLines = 0
        consumerLabel.lineBreakMode = .ByWordWrapping
        consumerLabel.textAlignment = .Right
        consumerLabel.translatesAutoresizingMaskIntoConstraints = false
        let leftArrowPath = UIBezierPath()
        start = CGPointZero
        leftArrowPath.moveToPoint(start)
        next = CGPoint(x: start.x-25, y: start.y-20)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x, y: next.y+10)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x-50, y: next.y)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x, y: next.y+20)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x+50, y: next.y)
        leftArrowPath.addLineToPoint(next)
        next = CGPoint(x: next.x, y: next.y+10)
        leftArrowPath.addLineToPoint(next)
        leftArrowPath.addLineToPoint(start)
        leftArrowPath.closePath()
        let leftArrowShape = UIImage.shapeImageWithBezierPath(leftArrowPath, fillColor: UIColor.clearColor(), strokeColor: UIColor.whiteColor(), strokeWidth: 1.0)
        let leftImageView = UIImageView(image: leftArrowShape)
        let consumerLabelStackView = UIStackView()
        consumerLabelStackView.addArrangedSubview(consumerLabel)
        consumerLabelStackView.addArrangedSubview(leftImageView)
        consumerLabelStackView.axis = .Vertical
        consumerLabelStackView.spacing = 10
        consumerLabelStackView.distribution = .EqualSpacing
        consumerLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelStackView = UIStackView()
        labelStackView.addArrangedSubview(driverlabelStackView)
        labelStackView.addArrangedSubview(consumerLabelStackView)
        labelStackView.axis = .Horizontal
        labelStackView.distribution = .EqualSpacing
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let screenStackView = UIStackView()
        screenStackView.addArrangedSubview(welcomeLabel)
        screenStackView.addArrangedSubview(labelStackView)
        screenStackView.axis = .Vertical
        screenStackView.distribution = .Fill
        screenStackView.spacing = 50
        screenStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(screenStackView)
        screenStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        screenStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        screenStackView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, constant: -20).active = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

/*
    UIImage function that creates image from BezierPath. Used to create image of arrows
    copied from http://digitalleaves.com/blog/2015/07/bezier-paths-in-practice-i-from-basic-shapes-to-custom-designable-controls/
*/
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
