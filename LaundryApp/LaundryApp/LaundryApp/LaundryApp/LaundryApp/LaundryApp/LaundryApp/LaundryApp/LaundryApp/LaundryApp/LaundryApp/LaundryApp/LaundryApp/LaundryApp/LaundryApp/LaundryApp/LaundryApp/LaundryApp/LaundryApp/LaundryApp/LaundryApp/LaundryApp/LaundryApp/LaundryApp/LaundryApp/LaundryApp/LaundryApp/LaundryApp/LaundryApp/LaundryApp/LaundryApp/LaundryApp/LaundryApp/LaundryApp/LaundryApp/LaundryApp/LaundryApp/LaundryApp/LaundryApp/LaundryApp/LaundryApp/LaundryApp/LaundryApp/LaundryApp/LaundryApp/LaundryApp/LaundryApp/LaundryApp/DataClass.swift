//
//  BasketItem.swift
//  LaundryApp
//
//  Created by ZoZy on 7/8/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class ProductItem {
    var code: String = ""
    var id: Int = 0
    var name: String = ""
    var image = String()
    var price: Int = 0
    var priceVND: Int = 0
    var amount: Int = 0
    var cat_id: Int = 0
    
    init(ID: Int, name: String, image: String, price: Int, cat_id: Int, code: String, priceVND: Int){
        self.id = ID
        self.name = name
        self.image = image
        self.price = price
        self.cat_id = cat_id
        self.code = code
        self.priceVND = priceVND
    }
    func imageview() ->  UIImageView {
        //        let imgname = self.image
        let image = UIImage(named: self.image)!
        let imageView = UIImageView(image: image)
        return imageView
    }
}

class Language {
    var name: String = ""
    var lang_id: Int = 0
    var currency: String = ""
    var code: String = ""
    init (name: String, id: Int, code: String, currency: String){
        self.name = name
        self.lang_id = id
        self.code = code
        self.currency = currency
    }
}

class CategoriesItem{
    var cat_id: Int = 0
    var code: String = ""
    init(cat_id: Int,code: String){
        self.cat_id=cat_id
        self.code = code
    }
}

class BasketItem{
    var id = Int()
    var quantity  = Int()
    init(id: Int, quantity: Int){
        self.id = id
        self.quantity = quantity
    }
}

class UserInfo{
    var mobile = ""
    var firstname = ""
    var lastname = ""
    var address = ""
    var birthday = ""
    var email = ""
    var token = ""
    var exp_date = ""
    func LoadData(){
        if let info: AnyObject = AppFunc().getNSObject("userinfo") {
            if let token = info.valueForKey(Keys.token) as? String{
                if(token == ""){
                    NSUserDefaults.standardUserDefaults().removeObjectForKey("userinfo")
                    SaveData()
                } else {
                    self.token = token
                    self.mobile = info.valueForKey(Keys.mobile) as! String
                    self.firstname = info.valueForKey(Keys.firstname) as! String
                    self.lastname = info.valueForKey(Keys.lastname) as! String
                    self.address = info.valueForKey(Keys.address) as! String
                    self.birthday = info.valueForKey(Keys.birthday) as! String
                    self.email = info.valueForKey(Keys.email) as! String
                    self.exp_date = info.valueForKey(Keys.expdate) as! String
                }
            }
        }
    }
    func SaveData(){
        var info : [String: String] = [:]
        info[Keys.mobile] = self.mobile
        info[Keys.firstname] = self.firstname
        info[Keys.lastname] = self.lastname
        info[Keys.address] = self.address
        info[Keys.birthday] = self.birthday
        info[Keys.email] = self.email
        info[Keys.token] = self.token
        info[Keys.expdate] = self.exp_date
        AppFunc().setNSObject(info, key: "userinfo")
    }
}