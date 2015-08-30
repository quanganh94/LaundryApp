//
//  SideMenuController.swift
//  LaundryApp
//
//  Created by ZoZy on 7/13/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//


import UIKit


class SideMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var yourTable: UITableView!
    
    @IBOutlet weak var urTableHeight: NSLayoutConstraint!
    @IBOutlet weak var ourTable: UITableView!
    
    @IBOutlet weak var ourTableHeight: NSLayoutConstraint!
    var urDetails = Array<CellInfo>()
    var ourDetails = Array<CellInfo>()
    //Register/ Login View
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    @IBOutlet weak var loginViewX: NSLayoutConstraint!
    
    var originloginViewX: CGFloat = 0
    //Account View
    @IBOutlet weak var accountView: UIView!
    
    @IBOutlet weak var helloLbl: UILabel!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    
    override func viewDidLoad() {
        //        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        urDetails.append(CellInfo(label: "SETTINGS".localized,id: 1))
        
        ourDetails.append(CellInfo(label: "CONTACT".localized,id: 3))
        
        adjustTableHeight()
        
        originloginViewX = self.loginViewX.constant
        
        var numberToolbar: UIToolbar = UIToolbar(frame: CGRectMake(self.view.frame.width/2-10, 0, self.view.frame.width, 50))
        let doneButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        doneButton.addTarget(self, action: "doneButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        doneButton.backgroundColor = UIColor(netHex:0x34AADC)
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        numberToolbar.addSubview(doneButton)
        
        phoneNum.inputAccessoryView = numberToolbar
        
        if appDelegate.userinfo.token != "" {
            loginView.hidden = true
            accountView.hidden = false
            if(appDelegate.userinfo.firstname != ""){
                helloLbl.text = "HELLO".localized + " " + appDelegate.userinfo.firstname
            } else {
                helloLbl.text = "HELLO".localized + " " + appDelegate.userinfo.mobile
            }
            self.loginViewX.constant = self.originloginViewX - 260
        }
    }
    
    
    func setLoggedIn(){
        loginView.hidden = true
        accountView.hidden = false
        if(appDelegate.userinfo.firstname != ""){
            helloLbl.text = "HELLO".localized + " " + appDelegate.userinfo.firstname
        } else {
            helloLbl.text = "HELLO".localized + " " + phoneNum.text
        }
        UIView.animateWithDuration(0.8, animations: {
            self.loginViewX.constant = self.originloginViewX - 260
        })
        passTF.resignFirstResponder()
    }
    
    func setLoggedOut(){
        loginView.hidden = false
        accountView.hidden = true
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.userinfo)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Keys.orderhistory)

        UIView.animateWithDuration(1, animations: {
            self.loginViewX.constant = self.originloginViewX
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == yourTable){
            return urDetails.count
        } else {
            return ourDetails.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView == yourTable){
            let cell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! SideMenuViewCell
            cell.label.text = urDetails[indexPath.row].label
            cell.id = urDetails[indexPath.row].id
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! SideMenuViewCell
            cell.label.text = ourDetails[indexPath.row].label
            cell.id = ourDetails[indexPath.row].id
            return cell
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SideMenuViewCell
        self.revealViewController().revealToggleAnimated(true)
        let front = self.revealViewController().frontViewController as! UINavigationController
        let viewVC = front.childViewControllers[0] as! HomeViewController
        
        if(cell.id == 1){
            viewVC.GoTo("setting")
        } else if(cell.id == 4){
            viewVC.GoTo("login")
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func adjustTableHeight(){
        let cell = yourTable.dequeueReusableCellWithIdentifier("menuCell") as! SideMenuViewCell
        var height = cell.frame.height*CGFloat(urDetails.count) - 1
        self.urTableHeight.constant = height
        
        height = cell.frame.height*CGFloat(ourDetails.count) - 1
        self.ourTableHeight.constant = height
    }
    @IBAction func loginbtn(sender: AnyObject) {
        login()
        
    }
    
    @IBAction func registerbtn(sender: AnyObject) {
        self.revealViewController().revealToggleAnimated(true)
        
        let front = self.revealViewController().frontViewController as! UINavigationController
        
        let viewVC = front.childViewControllers[0] as! HomeViewController
        viewVC.GoTo("register")
    }
    
    @IBAction func viewAccount(sender: AnyObject) {
        self.revealViewController().revealToggleAnimated(true)
        let front = self.revealViewController().frontViewController as! UINavigationController
        
        let viewVC = front.childViewControllers[0] as! HomeViewController
        viewVC.GoTo("account")
    }
    
    @IBAction func viewOrder(sender: AnyObject) {
        self.revealViewController().revealToggleAnimated(true)
        let front = self.revealViewController().frontViewController as! UINavigationController
        
        let viewVC = front.childViewControllers[0] as! HomeViewController
        viewVC.GoTo("orderhistory")
    }
    
    @IBAction func Logout(sender: AnyObject) {
        setLoggedOut()
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if(textField == passTF){
            login()
        }
        textField.resignFirstResponder()
        return true
    }
    func doneButton(sender:UIButton)
    {
        phoneNum.resignFirstResponder()
        passTF.becomeFirstResponder()
        
    }
    
    func login(){
        if let mobile = phoneNum.text {
            appDelegate.userinfo.mobile = mobile
            let CN = ConnectServerAPI()
            var params : [String: AnyObject] = [:]
            params["mobile"] = phoneNum.text
            params["password"] = passTF.text
            let alert = AlertManager(view: self)
            alert.Wait()
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                var mess = ""
                if let json: AnyObject? = CN.POST(params,url: Constants.LOGIN){
                    if(json!.valueForKey("status") as! String == Constants.STATUS_SUCCESS){
                        mess = Constants.STATUS_SUCCESS
                        var data =  Array<AnyObject>()
                        data =  json!.valueForKey("data")! as! Array<AnyObject>
                        var date = (data[1].valueForKey("date")!) as! String
                        date = date.substringToIndex(advance(date.startIndex, 19))
                        self.appDelegate.userinfo.mobile = mobile
                        self.appDelegate.userinfo.token = "\(data[0])"
                        self.appDelegate.userinfo.exp_date = date
                        //Get userinfo data
                        if let infojson: AnyObject = CN.GET(Constants().ACCOUNT_INFO(mobile, token: self.appDelegate.userinfo.token)){
                            let info: AnyObject = infojson.valueForKey("data")!
                            println(info)
                            if let firstname = info.valueForKey("firstname") as? String{
                                self.appDelegate.userinfo.firstname = "\(firstname)"
                            }
                            if let lastname = info.valueForKey("lastname") as? String{
                                self.appDelegate.userinfo.lastname = "\(lastname)"
                            }
                            if let birthday = info.valueForKey("birthday") as? String{
                                self.appDelegate.userinfo.birthday = "\(birthday)"
                            }
                            if let address = info.valueForKey("address") as? String{
                                self.appDelegate.userinfo.address = "\(address)"
                            }
                            if let email = info.valueForKey("email") as? String{
                                self.appDelegate.userinfo.email = "\(email)"
                            }
                        }
                        self.appDelegate.userinfo.SaveData()
                    } else {
                        mess = "WRONG_USER".localized
                    }
                } else {
                    mess = "SERVER_ERROR".localized
                }
                dispatch_async(dispatch_get_main_queue()) {
                    alert.dismissWait()
                    if(mess == Constants.STATUS_SUCCESS){
                        self.setLoggedIn()
                    } else {
                        alert.showAlert("ERROR".localized, message: mess)
                    }
                }
             
            }
        }
        passTF.resignFirstResponder()
    }
    
    func LoginProgress(data: AnyObject){
        
    }
    
}

class CellInfo {
    var label: String = ""
    var img: String = ""
    var id: Int = 0
    
    init(label: String, id: Int){
        self.label = label
        self.id = id
    }
}
