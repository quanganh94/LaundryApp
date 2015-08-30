//
//  CustomTableCell.swift
//  LaundryApp
//
//  Created by ZoZy on 7/7/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//


import UIKit

class CustomProductCell: UITableViewCell {
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var item: ProductItem?
    var am: Int = 0
    
      override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(self.am==0){
            amount.hidden=true
        }
        
    }
    
    func setAmount(){
        if(self.am==0){
            deleteBtn.hidden=true
            amount.hidden=true
        }
        else{
            deleteBtn.hidden=false
            amount.text = "\(am)"
            amount.hidden=false
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let imgtrans :CGAffineTransform = self.img.transform
        let labeltrans :CGAffineTransform = self.img.transform
        
        self.am++
        add()
        UIView.animateWithDuration(0.15, animations: {
            // Animations
            self.img.transform = CGAffineTransformMakeScale(1.1,1.1)
            self.amount.transform = CGAffineTransformMakeScale(1.1,1.1)
            }, completion: { finished in
                self.amount.text = "\(self.am)"
                // remove the views
                if finished {
                    UIView.animateWithDuration(0.15, animations: {
                        self.img.transform = imgtrans
                        self.amount.transform = labeltrans
                    })
                }
        })
        
    }
    
    
    func add(){
        appDelegate.addtoBasket(self.item!,am: -1)
        setAmount()
    }
    func subtract(){
        let amount = appDelegate.removefromBasket(self.item!)
        self.am = amount
        setAmount()
    }
    
    @IBAction func deleteItem(sender: AnyObject) {
        let imgtrans :CGAffineTransform = self.img.transform
        let labeltrans :CGAffineTransform = self.img.transform
        subtract()
        UIView.animateWithDuration(0.1, animations: {
            // Animations
            self.img.transform = CGAffineTransformMakeTranslation(3,0)
            self.amount.transform = CGAffineTransformMakeScale(1.1,1.1)
            }, completion: { finished in
                self.amount.text = "\(self.am)"
                // remove the views
                if finished {
                    UIView.animateWithDuration(0.1, animations: {
                        self.img.transform = imgtrans
                        self.amount.transform = labeltrans
                    })
                }
        })

    }
    
    
}
