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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
