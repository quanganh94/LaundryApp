//
//  OrderHistoryViewController.swift
//  LaundryApp
//
//  Created by ZoZy on 8/25/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class OrderHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var listOrder = Array<AnyObject>()
    var listcompleted = Array<AnyObject>()
    var listpending = Array<AnyObject>()
    var listview = Array<AnyObject>()
//
    var status_filter = 1
    @IBOutlet weak var state: UISegmentedControl!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        if let history: AnyObject = AppFunc().getNSObject(Keys.orderhistory) {
            listOrder = history as! Array<AnyObject>
            splitData()
        }
        loadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listview.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderHistoryCell") as! OrderHistoryViewCell
        let row: AnyObject = listview[indexPath.row]
        cell.lbl_ordercode.text = row.valueForKey("code") as? String
        cell.lbl_Price.text = row.valueForKey("total") as? String
        cell.lbl_pickupDate.text = row.valueForKey("pickup") as? String
        cell.lbl_deliveryDate.text = row.valueForKey("delivery") as? String
        cell.set_status(row.valueForKey("status") as! Int)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row: AnyObject = listview[indexPath.row]
        println(row.valueForKey("status"))
    }
    func loadData(){
        let CN = ConnectServerAPI()
        self.indicator.hidden = false
        let alert = AlertManager(view: self)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var mess = ""
            if let infojson: AnyObject = CN.GET(Constants().ORDER_HISTORY(self.appDelegate.userinfo.mobile)){
                let message: String = infojson.valueForKey("status") as! String
                if (message == Constants.STATUS_SUCCESS) {
                    self.listOrder = infojson.valueForKey("data") as! Array<AnyObject>
                    self.indicator.hidden = true
                    self.splitData()
                    AppFunc().setNSObject(self.listOrder, key: Keys.orderhistory)
                } else {
                    mess = "ERROR".localized
                }
                
            } else {
                mess = "SERVER_ERROR".localized
            }
            dispatch_async(dispatch_get_main_queue()) {
                if(mess != "") {
                    alert.showAlert(mess, message: "")
                }
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
    }
    
    @IBAction func Switch(sender: AnyObject) {
        switch self.state.selectedSegmentIndex
        {
        case 0:
            status_filter = 1
            break
        case 1:
            status_filter = 2
            break
        default: break
        }
        splitData()
    }
    
    
    func splitData(){
        status_filter = self.state.selectedSegmentIndex + 1
        println(status_filter)
        listview.removeAll(keepCapacity: false)
        for row in listOrder {
            if(row.valueForKey("status") as! Int == status_filter){
                listview.append(row)
            }
        }
        self.tableView.reloadData()
    }
}
