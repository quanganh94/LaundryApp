//
//  BasketViewController.swift
//  LaundryApp
//
//  Created by ZoZy on 7/8/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class BasketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var basketData =  Array<ProductItem>()
    var total: Double = 0
    var oldtotalvalue: Double = 0
    var originalFrame: CGRect!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var couponField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var discountText: UILabel!
    @IBOutlet weak var oldTotal: UILabel!
    var coupon = ""
    var discount_amount: Double = 0
    override func viewDidLoad() {
        originalFrame = self.view.frame
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        for basketItem in appDelegate.basket {
            for item in appDelegate.Products {
                if(basketItem.id == item.id){
                    basketData.append(item)
                }
            }
        }
        couponField.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "calTotal", name: "Change", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "DeleteRow", name: "DeleteRow", object: nil)
        calTotal()
    }
    
    func calTotal(){
        total = 0
        var vn = false
        
        if(appDelegate.lang_id == 2) { vn = true }
        for item in basketData {
            if(vn){
                total += Double(item.priceVND*item.amount)
            } else {
                total += Double(item.price*item.amount)
            }
        }
        if(total != oldtotalvalue || discount_amount != 0){
            let saved = (total*discount_amount)
            totalLabel.text = "\(appDelegate.currency) \(AppFunc().decimalNum(total - saved))"
            if(self.discount_amount != 0){
                let attribute = NSMutableAttributedString(string: "\(AppFunc().decimalNum(total))")
                attribute.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attribute.length))
                oldTotal.attributedText = attribute

                self.discountText.text = Constants().DISCOUNT_TEXT(self.discount_amount, price: saved)
            } else {
                oldTotal.text = ""
                self.discountText.text = ""
            }
            oldtotalvalue = total
        }
    }
    
    func DeleteRow(){
        basketData.removeAll(keepCapacity: true)
        for basketItem in appDelegate.basket {
            for item in appDelegate.Products {
                if(basketItem.id == item.id){
                    basketData.append(item)
                }
            }
        }
        tableView.reloadData()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BasketCell") as! BasketTableCell
        let data: ProductItem = basketData[indexPath.row]
        cell.item = data
        if(appDelegate.lang_id == 2){
            
            cell.lblPrice.text = " \(AppFunc().decimalNum(data.priceVND*data.amount)) "
        } else {
            cell.lblPrice.text = "$\(data.price*data.amount)"
        }
        cell.img.image = UIImage(named: data.image)
        cell.labetTitle.text=data.name
        cell.amountText.text = "\(data.amount)"
        cell.amount = data.amount
        cell.setAmount()
        cell.setup()
        cell.button.addTarget(self, action: "btnClick", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func btnClick(){
        calTotal()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketData.count
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.15, animations: {
            self.view.frame = self.originalFrame
            textField.resignFirstResponder()
            }, completion: { finished in
                if(textField == self.couponField && textField.text != ""){
                    self.checkCoupon()
                }

            })
        return false
    }
    func checkCoupon(){
        let CN = ConnectServerAPI()
        let alert = AlertManager(view: self)
        alert.Wait()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var mess = ""
            if let infojson: AnyObject = CN.GET(Constants().COUPON_URL(self.couponField.text)){
                let info: AnyObject = infojson.valueForKey("data")!
                if (!(info is NSNull)) {
                    if let exp:NSDate = AppFunc().getDateFromString(info.valueForKey("expired_at")! as! String){
                        if(NSDate().compare(exp) == NSComparisonResult.OrderedDescending){
                            mess = "COUPON_EXP".localized
                        } else {
                            mess = ""
                            self.coupon = self.couponField.text
                            let discount = info.valueForKey("discount")! as! Double
                            self.discount_amount = discount/100
                        }
                    } else {
                        mess = "WRONG_DATA_FORMAT".localized
                    }
                } else {
                    mess = "WRONG_COUPON".localized
                }
            
            } else {
                mess = "SERVER_ERROR".localized
            }
            dispatch_async(dispatch_get_main_queue()) {
                alert.dismissWait()
                self.calTotal()
                if(mess != "") {
                    alert.showAlert(mess, message: "")
                }
            }
            
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        AppFunc().PushUpKeyboard(self.view, textField: textField, originalFrame: originalFrame)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Checkout"){
            let checkout = segue.destinationViewController as! CheckoutViewController
            checkout.coupon = self.coupon
        }
    }
    func cal_discount(){
        
    }
}