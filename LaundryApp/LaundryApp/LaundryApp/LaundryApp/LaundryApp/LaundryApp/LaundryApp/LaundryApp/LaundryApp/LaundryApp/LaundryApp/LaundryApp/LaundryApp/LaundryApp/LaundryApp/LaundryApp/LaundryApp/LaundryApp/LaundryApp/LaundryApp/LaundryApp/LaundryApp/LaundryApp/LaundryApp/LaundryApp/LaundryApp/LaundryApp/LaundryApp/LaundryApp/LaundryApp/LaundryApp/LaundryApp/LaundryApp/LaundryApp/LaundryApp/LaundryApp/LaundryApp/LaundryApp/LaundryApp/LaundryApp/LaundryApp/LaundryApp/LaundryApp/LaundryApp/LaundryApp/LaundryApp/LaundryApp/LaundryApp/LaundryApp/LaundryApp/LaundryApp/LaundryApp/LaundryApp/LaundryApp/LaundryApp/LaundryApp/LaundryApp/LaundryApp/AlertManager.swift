//
//  Alert.swift
//  LaundryApp
//
//  Created by ZoZy on 7/27/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

//
//  AlertManager.swift
//  Manager
//
//  Created by ZoZy on 7/2/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class AlertManager
{
    let wait = UIAlertController(title: "LOADING".localized,
        message: "WAIT".localized, preferredStyle: .Alert)
    var CurrentVC = UIViewController()
    init(view: UIViewController){
        CurrentVC = view
        var height:NSLayoutConstraint = NSLayoutConstraint(item: wait.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 90)
        height.priority = 750
        wait.view.addConstraint(height)
        wait.view.addSubview(spinner())
    }
    
    func spinner() -> UIActivityIndicatorView {
        var spinner : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        spinner.center =  CGPointMake(130.5, 75)
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        spinner.startAnimating()
        return spinner
    }
    
    func Wait(){
        if wait.isBeingPresented(){
            wait.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.CurrentVC.presentViewController(self.wait, animated: true, completion: nil)
            })
        } else {
            self.CurrentVC.presentViewController(self.wait, animated: true, completion: nil)
        }
    }
    func Wait(message: String){
        wait.message = message
        if wait.isBeingPresented(){
            wait.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.CurrentVC.presentViewController(self.wait, animated: true, completion: nil)
            })
        } else {
            self.CurrentVC.presentViewController(self.wait, animated: true, completion: nil)
        }
    }
    func dismissWait(){
        wait.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title,
            message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(dismissAction)
        wait.dismissViewControllerAnimated(true, completion: { () -> Void in
                self.CurrentVC.presentViewController(alert, animated: true, completion: nil)
        })
        if !alert.isBeingPresented() {
            self.CurrentVC.presentViewController(alert, animated: true, completion: nil)
        }
//        else {
//            self.CurrentVC.presentViewController(alert, animated: true, completion: nil)
//        }
//        
        
    }
    
}
