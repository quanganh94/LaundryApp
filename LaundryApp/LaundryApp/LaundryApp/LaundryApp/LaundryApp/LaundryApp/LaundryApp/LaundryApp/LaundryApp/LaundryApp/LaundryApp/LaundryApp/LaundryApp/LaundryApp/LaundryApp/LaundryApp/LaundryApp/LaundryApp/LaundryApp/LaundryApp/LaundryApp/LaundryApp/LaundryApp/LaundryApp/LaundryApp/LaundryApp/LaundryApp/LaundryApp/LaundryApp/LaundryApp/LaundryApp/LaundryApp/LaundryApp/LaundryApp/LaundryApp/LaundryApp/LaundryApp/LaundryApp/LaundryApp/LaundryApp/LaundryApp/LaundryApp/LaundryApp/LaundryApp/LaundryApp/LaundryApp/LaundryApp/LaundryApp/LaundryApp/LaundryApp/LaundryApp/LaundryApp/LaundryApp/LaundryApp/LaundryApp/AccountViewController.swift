//
//  AccountViewController.swift
//  LaundryApp
//
//  Created by ZoZy on 8/13/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit
class AccountViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        var numberToolbar: UIToolbar = UIToolbar(frame: CGRectMake(self.view.frame.width/2-10, 0, self.view.frame.width, 50))
        let doneButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        doneButton.addTarget(self, action: "doneButton:", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor(netHex:0x34AADC)
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        numberToolbar.addSubview(doneButton)
        mobile.inputAccessoryView = numberToolbar
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        email.text = appDelegate.userinfo.email
        firstname.text = appDelegate.userinfo.firstname
        lastname.text = appDelegate.userinfo.lastname
        dob.text = appDelegate.userinfo.birthday
        address.text = appDelegate.userinfo.address
        mobile.text = appDelegate.userinfo.mobile
        setupDatePicker()
        
    }
    
    func doneButton(sender:UIButton)
    {
        if(dob.isFirstResponder()){
            address.becomeFirstResponder()
        } else if(mobile.isFirstResponder()){
            password.becomeFirstResponder()
        }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dob.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func setupDatePicker(){
        let inputView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, 240))
        inputView.backgroundColor = UIColor(netHex:0x34AADC)
        
        var datePicker = UIDatePicker(frame: CGRectMake(0, 40, 0, 0))
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.maximumDate = NSDate()
        inputView.addSubview(datePicker) // add date picker to UIView
        //            self.collectionTF.inputView = datePicker
        let doneButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        inputView.addSubview(doneButton)
        doneButton.addTarget(self, action: "doneButton:", forControlEvents: UIControlEvents.TouchUpInside) // set button click event
        datePicker.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        //            handleDatePicker(datePicker)
        
        
        self.dob.inputView = inputView
        
    }
    
    @IBAction func update(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var params : [String: AnyObject] = [:]
        params["mobile"] = mobile.text
        params["password"] = password.text
        params["firstname"] = firstname.text
        params["lastname"] = lastname.text
        params["address"] = address.text
        params["birthday"] = dob.text
        params["email"] = email.text
        var json : [String: AnyObject] = [:]
        json["content"] = params
        json["token"] = delegate.userinfo.token
        let CN = ConnectServerAPI()
        
        let alert = AlertManager(view: self)
        alert.Wait()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var mess = ""
            if let json: AnyObject = CN.POST(json,url: Constants().ACCOUNT_UPDATE(self.mobile.text)){
                println(json)
                if(json.valueForKey("status") as! String == Constants.STATUS_SUCCESS){
                    mess = Constants.STATUS_SUCCESS
                }
            }
            dispatch_async(dispatch_get_main_queue()) {
                alert.dismissWait()
                if(mess == Constants.STATUS_SUCCESS) {
                    alert.showAlert("SUCCESS".localized, message: "ACCOUNT_CHANGED".localized)
                    delegate.userinfo.LoadData()
                }
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField == email){
            firstname.becomeFirstResponder()
        } else if (textField == firstname){
            lastname.becomeFirstResponder()
        } else if (textField == lastname){
            dob.becomeFirstResponder()
        } else if (textField == address){
            
        }
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
    }
    
}