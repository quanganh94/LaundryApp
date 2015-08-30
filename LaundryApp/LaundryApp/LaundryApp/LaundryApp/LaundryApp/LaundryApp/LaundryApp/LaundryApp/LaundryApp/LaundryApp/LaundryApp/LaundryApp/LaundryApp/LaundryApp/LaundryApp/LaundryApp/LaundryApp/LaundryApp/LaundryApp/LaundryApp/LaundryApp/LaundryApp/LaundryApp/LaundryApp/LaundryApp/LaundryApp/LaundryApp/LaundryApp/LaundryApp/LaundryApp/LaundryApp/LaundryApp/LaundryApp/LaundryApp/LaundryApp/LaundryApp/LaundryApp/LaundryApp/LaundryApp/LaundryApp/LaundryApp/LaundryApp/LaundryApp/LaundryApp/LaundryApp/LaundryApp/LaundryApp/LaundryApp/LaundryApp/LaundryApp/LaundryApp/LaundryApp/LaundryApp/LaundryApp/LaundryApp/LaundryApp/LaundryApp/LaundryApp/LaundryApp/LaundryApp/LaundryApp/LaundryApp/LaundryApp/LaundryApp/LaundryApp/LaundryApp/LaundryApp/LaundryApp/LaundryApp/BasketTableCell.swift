//
//  BasketTableCell.swift
//  LaundryApp
//
//  Created by ZoZy on 7/9/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class BasketTableCell: UITableViewCell {
    
    @IBOutlet weak var labetTitle: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var amountText: UITextField!
    var item: ProductItem!
    var amount: Int = 0
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var timer = NSTimer()
    var edit = false
    func setup(){
        let width = UIApplication.currentViewController()!.view.frame.width
        var numberToolbar: UIToolbar = UIToolbar(frame: CGRectMake(width/2-10, 0, width, 50))
        let doneButton = UIButton(frame: CGRectMake(0, 0, width, 50))
        doneButton.addTarget(self, action: "dismissNumberPad", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor(netHex:0x34AADC)
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        numberToolbar.addSubview(doneButton)
        amountText.inputAccessoryView = numberToolbar
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timerFinished:", userInfo: nil, repeats: false)
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        timer.invalidate()
        if(!edit){
            let imgtrans :CGAffineTransform = self.img.transform
            let amounttrans = self.amountText.transform
            self.amount++
            add(-1)
            UIView.animateWithDuration(0.15, animations: {
                // Animations
                self.img.transform = CGAffineTransformMakeScale(1.2,1.2)
                self.amountText.transform = CGAffineTransformMakeScale(1.2,1.2)
                
                }, completion: { finished in
                    self.setAmount()
                    // remove the views
                    if finished {
                        UIView.animateWithDuration(0.15, animations: {
                            self.img.transform = imgtrans
                            self.amountText.transform = amounttrans
                        })
                    }
            })
        }
    }
    func add(am: Int){
        appDelegate.addtoBasket(self.item, am: am)
    }
    
    func setAmount(){
        if(self.appDelegate.lang_id == 2){
            self.lblPrice.text = "\(AppFunc().decimalNum(self.item.priceVND*self.item.amount))"
        } else {
            self.lblPrice.text = "\(AppFunc().decimalNum(self.item.price*self.item.amount))"
        }
        self.amountText.text = "\(self.amount)"
    }
    
    func timerFinished(timer: NSTimer) {
        edit = true
        amountText.becomeFirstResponder()
    }
    
    
    @IBAction func subtractItem(sender: AnyObject) {
        let amount = appDelegate.removefromBasket(self.item)
        self.amount = amount
        self.amountText.text = "\(amount)"
    }
    
    func dismissNumberPad() {
        edit = false
        if(amountText.text != "") {
            self.amount = (amountText.text).toInt()!
            add(self.amount)
            self.setAmount()
        } else {
            self.amountText.text = "\(self.amount)"
        }
        amountText.resignFirstResponder()
    }
    
    
}
