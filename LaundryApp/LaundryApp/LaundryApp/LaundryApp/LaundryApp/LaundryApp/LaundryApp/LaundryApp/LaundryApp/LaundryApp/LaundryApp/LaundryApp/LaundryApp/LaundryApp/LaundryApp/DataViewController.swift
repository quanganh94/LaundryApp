//
//  FirstViewController.swift
//  LaundryApp
//
//  Created by ZoZy on 7/7/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var tableData =  Array<ProductItem>()
    var cat_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        for item in appDelegate.Products {
            if(item.cat_id == self.cat_id){
                tableData.append(item)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomProductCell
        let data: ProductItem = tableData[indexPath.row]
            cell.item = data
        
        if(appDelegate.lang_id == 2){
            cell.price.text = " \(AppFunc().decimalNum(data.priceVND))VND  "
        }
        else {
            cell.price.text = "$\(data.price)"
        }
            cell.img.image = UIImage(named: data.image)
            cell.name.text=data.name
            cell.am = data.amount
            cell.setAmount()
        return cell
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.allowsSelection = NO
        print("select row ")
        print(indexPath.row)
        
    }
    

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
}
