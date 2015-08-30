    //
    //  RegisterViewController.swift
    //  LaundryApp
    //
    //  Created by ZoZy on 7/30/15.
    //  Copyright (c) 2015 ZoZy. All rights reserved.
    //
    
    import UIKit
    
    class RegisterViewController: UIViewController {
        
        @IBOutlet weak var mobile: UITextField!
        @IBOutlet weak var password: UITextField!
        @IBOutlet weak var email: UITextField!
        @IBOutlet weak var firstname: UITextField!
        @IBOutlet weak var lastname: UITextField!
        @IBOutlet weak var birthday: UITextField!
        @IBOutlet weak var address: UITextField!
        
        
        override func viewDidLoad() {
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
            setupDatePicker()
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
                        handleDatePicker(datePicker)
            
            
            self.birthday.inputView = inputView
            
        }
        //
        func doneButton(sender:UIButton)
        {
            if(birthday.isFirstResponder()){
                address.becomeFirstResponder()
            } else if(mobile.isFirstResponder()){
                password.becomeFirstResponder()
            }
        }
        
        func handleDatePicker(sender: UIDatePicker) {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthday.text = dateFormatter.stringFromDate(sender.date)
        }
        
        
        @IBAction func register(sender: AnyObject) {
            if(AppFunc().checkPhone(mobile.text)){
                reset(mobile)
                let CN = ConnectServerAPI()
                var params : [String: AnyObject] = [:]
                params["mobile"] = mobile.text
                params["password"] = password.text
                params["firstname"] = firstname.text
                params["lastname"] = lastname.text
                params["address"] = address.text
                params["birthday"] = birthday.text
                params["email"] = email.text
                let alert = AlertManager(view: self)
                alert.Wait()
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    var mess = ""
                    if let json: AnyObject = CN.POST(params,url: Constants.REGISTER){
                        println(json)
                        if(json.valueForKey("status") as! String == Constants.STATUS_SUCCESS){
                            mess = Constants.STATUS_SUCCESS
                        } else {
                            mess = json.valueForKey("message") as! String
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        alert.dismissWait()
                        if(mess == Constants.STATUS_SUCCESS) {
                            alert.showAlert(mess, message: "")
                        }
                    }
                }
                
            } else {
                highlight(mobile)
            }
        }
        override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
            self.view.endEditing(true
            )
        }
        
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            if (textField === password)
            {
                email.becomeFirstResponder()
            } else if (textField == email){
                firstname.becomeFirstResponder()
            } else if (textField == firstname){
                lastname.becomeFirstResponder()
            } else if (textField == lastname){
                birthday.becomeFirstResponder()
            }
            return true
        }
        
        func highlight(TF: UITextField){
            TF.backgroundColor = UIColor(netHex: 0xff00001)
        }
        func reset(TF: UITextField){
            TF.backgroundColor = UIColor.whiteColor()
        }
        override func viewWillAppear(animated: Bool) {
            let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        }
    }
