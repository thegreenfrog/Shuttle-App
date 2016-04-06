//
//  UIViewExtensions.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 4/6/16.
//
//

import Foundation
import UIKit

extension UIView {
    func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
    
    func removeConstraints() {
        if let supView = self.superview {
            for con in supView.constraints {
                if con.firstItem as? UIView == self || con.secondItem as? UIView == self {
                    print("removed constraint")
                    supView.removeConstraint(con)
                }
            }
        }
        for con in self.constraints {
            self.removeConstraint(con)
        }
    }
}