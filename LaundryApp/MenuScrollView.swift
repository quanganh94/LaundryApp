//
//  CustomScrollView.swift
//  LaundryApp
//
//  Created by ZoZy on 7/8/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//
// Scroll when touch on button
import UIKit

class CustomScrollView: UIScrollView {
    
    override func touchesShouldCancelInContentView(view: UIView!) -> Bool {
        if (view.isKindOfClass(UIButton)) {
            return true
        }
        return super.touchesShouldCancelInContentView(view)
        
    }
    
}