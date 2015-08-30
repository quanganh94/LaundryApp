//
//  NavigationSegue.swift
//  LaundryApp
//
//  Created by ZoZy on 7/6/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class NavigationSegue: UIStoryboardSegue {
    
    override func perform() {
        
        let tabBarController = self.sourceViewController as! HomeViewController
        
        let destinationController = self.destinationViewController as! DataViewController
        
        for view in tabBarController.placeHolder.subviews as! [UIView] {
            view.removeFromSuperview()
        }
        
        tabBarController.currentCat = self.identifier!
        
        for item in tabBarController.appDelegate.Categories {
            if(item.code == self.identifier){
                destinationController.cat_id = item.cat_id
            }
        }
        // Add view to placeholder view
        tabBarController.currentViewController = destinationController
        tabBarController.placeHolder.addSubview(destinationController.view)
        if( tabBarController.transitionfromRight == 1 ){
            tabBarController.placeHolder.slideInFromRight(duration: 0.4, completionDelegate: self)

        } else if(tabBarController.transitionfromRight == -1) {
            tabBarController.placeHolder.slideInFromLeft(duration: 0.4, completionDelegate: self)
        }
        // Set autoresizing
        tabBarController.placeHolder.setTranslatesAutoresizingMaskIntoConstraints(false)
        destinationController.view.setTranslatesAutoresizingMaskIntoConstraints(false)
       
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-10)-[v1]-(-10)-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.placeHolder.addConstraints(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[v1]-0-|", options: .AlignAllTop, metrics: nil, views: ["v1": destinationController.view])
        
        tabBarController.placeHolder.addConstraints(verticalConstraint)
        
        tabBarController.placeHolder.layoutIfNeeded()
        destinationController.didMoveToParentViewController(tabBarController)
        
    }
    
}
