//
//  NavigationThemes.swift
//  LaundryApp
//
//  Created by ZoZy on 7/17/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class NavigationThemes: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Status bar white font
        self.navigationBar.tintColor = UIColor.whiteColor()
        
    }
}