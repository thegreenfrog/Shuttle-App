//
//  VCAnimator.swift
//  Shuttle_Application
//
//  Created by Chris Lu on 4/25/16.
//
//

import UIKit

//Class used to create dissolve transition animation between RegisterVC and the main app
class VCAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 2.0
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        toViewController.view.frame = CGRectOffset(finalFrameForVC, 0.0, 0.0)
        toViewController.view.alpha = 0.0
        containerView!.addSubview(toViewController.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .TransitionCrossDissolve, animations: {
            toViewController.view.alpha = 1.0
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
                
        })
    }

}
