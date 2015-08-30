//
//  OrderHistoryCellView.swift
//  LaundryApp
//
//  Created by ZoZy on 8/25/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

class OrderHistoryViewCell: UITableViewCell {
    
    @IBOutlet weak var img_Status: UIImageView!
    @IBOutlet weak var lbl_OrderDate: UILabel!
    @IBOutlet weak var lbl_pickupDate: UILabel!
    @IBOutlet weak var lbl_deliveryDate: UILabel!
    @IBOutlet weak var lbl_Price: UILabel!
    @IBOutlet weak var lbl_ordercode: UILabel!
    

    func set_status(status: Int){
        switch status
        {
            case 1:
                self.img_Status.image = UIImage(named: "process.png")
            break
            case 2:
                self.img_Status.image = UIImage(named: "complete.png")
            break
            default:
            break
        }
    }
}