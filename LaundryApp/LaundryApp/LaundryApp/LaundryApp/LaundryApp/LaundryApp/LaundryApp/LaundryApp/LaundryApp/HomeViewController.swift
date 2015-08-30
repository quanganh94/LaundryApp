//
//  ViewController.swift
//  LaundryApp
//
//  Created by ZoZy on 7/6/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit
import SpriteKit

class HomeViewController: UIViewController,UIScrollViewDelegate {
    
    var currentViewController: UIViewController?
    var height: CGFloat = 0
    var width: CGFloat = 0
    var scrollrate: CGFloat = 1
    var scrollBar = UIView()
    var transitionfromRight = 1
    var currentButtonPosition: CGFloat = -1
    var currentBtnIndex = 0
    var isScrollingSelect = false
    var isScrollingFinished = false
    var currentCat: String = ""
    var delta: CGFloat = 0
    var screenWidth: CGFloat = 0
    var sideBarSegue = ""
    
    
    @IBOutlet weak var placeHolder: UIView!
    
    @IBOutlet weak var basketButton: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var lblamount: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var collectionOfButtons: Array<UIButton>!
    
    var segueIdenty: [String]! = []
    
    var position: CGFloat = 0
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        for item in appDelegate.Categories {
            segueIdenty.append(item.code)
        }
              btnAtPoint = collectionOfButtons[0] as UIButton
        height = scrollView.frame.size.height
        width = collectionOfButtons[0].frame.size.width
        screenWidth = self.view.frame.size.width
        position=0
        
        scrollView.contentSize = CGSizeMake(width*6, scrollView.frame.height)
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
        let a = scrollView.contentSize.width-width
        let b = self.view.frame.width-width
        
        if(a != b){
            scrollrate = a/(a-b)
        }
        
        if(scrollrate<0) {
            scrollrate = -scrollrate
        }
        let image = UIImage(named: "scrollbar.png")!
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPoint(x: 0, y: height - 3 ), size:CGSizeMake(width, 3))
        scrollView.addSubview(imageView)
        scrollBar = scrollView.subviews[6] as! UIView
        self.view.addSubview(scrollView)
        appDelegate.checkAmount()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
//            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
        }
        //        self.revealViewController().rearViewRevealWidth = 62
        collectionOfButtons[1].sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        let tapRec = UITapGestureRecognizer()
        tapRec.addTarget(self, action: "basket")
        lblamount.addGestureRecognizer(tapRec)
    }
    
    func basket(){
        basketButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    func ArragementMenu(){
        for button in collectionOfButtons {
            var frame:CGRect = button.frame as CGRect
            frame.origin.x = position
            button.frame = frame
            position += width
            //            println(button.frame.origin.x)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        if(self.position<self.width*6){
            ArragementMenu()
        }
        
    }
    
    func centerScrolling(){
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(contains(segueIdenty, segue.identifier!)) {
            
            for btn in collectionOfButtons {
                btn.selected = false
            }
            
            let button = sender as! UIButton
            let senderPosition = button.frame.origin.x
            if(currentCat == segue.identifier!) {
                transitionfromRight = 0
            } else {
                if(senderPosition > currentButtonPosition){
                    transitionfromRight = 1
                } else {
                    transitionfromRight = -1
                }
            }
            
            button.selected=true
            ScrollBarPosition(senderPosition)
            currentButtonPosition = senderPosition
            scroll()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var btnAtPoint: UIButton?
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        for btn in collectionOfButtons {
            let x = btn.frame.origin.x
            let scrollx = scrollView.contentOffset.x*scrollrate + width/2
            if(scrollx > x && scrollx < x+width ){
                ScrollBarPosition(x)
            }
        }
    }
    
    func scroll(){
        var offsetX = (currentButtonPosition - width/2)/scrollrate
        if(offsetX < 0) {
            offsetX = 0
        }
        UIView.animateWithDuration(0.5, animations: {
            self.scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        })
    }
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if(isScrollingFinished){
        
        delta = btnAtPoint!.frame.origin.x - currentButtonPosition
        if(delta != 0){
            btnAtPoint!.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }
        }
    }
    
    
    //    scrollview
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        delta = btnAtPoint!.frame.origin.x - currentButtonPosition
        if(delta != 0){
            btnAtPoint!.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        }
    }
    
    func ScrollBarPosition(position: CGFloat){
        var fr = scrollBar.frame as CGRect
        fr.origin.x=position
        isScrollingFinished = false
        UIView.animateWithDuration(0.2, animations: {
             self.scrollBar.frame = fr
            }, completion: { finished in
                if(finished){
                    self.isScrollingFinished = true
                }
                
        })
        for btn in collectionOfButtons {
            let x = btn.frame.origin.x
            let scrollx = position+width/2
            if(scrollx > x && scrollx < x+width ){
                btnAtPoint=btn
                btn.selected=true
            } else {
                btn.selected=false
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        collectionOfButtons[0].sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        if(lblamount != nil){
            if(appDelegate.totalItem() > 0){
                let total = appDelegate.totalItem()
                lblamount.text = "\(total)"
            }
        }
    }
    
    func GoTo(identy: String){
        performSegueWithIdentifier(identy, sender: nil)
    }
    
    }

