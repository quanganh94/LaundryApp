//
//  Constants.swift
//  LaundryApp
//
//  Created by ZoZy on 8/13/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import Foundation
struct Constants {
    static let SERVER_URL = "http://laundry.hhtv.vn/v1/"
    static let LOGIN = "login"
    static let REGISTER = "register"
    static let ACCOUNT = "accounts"
    static let ORDER = "orders"
    static let COUPON = "coupons"
    static let STATUS_SUCCESS = "success"
    static let STATUS_FAIL = "fail"
    static let CODE_SUCCESS = 200
    static let CODE_BAD_REQUEST = 400
    static let MESSAGE_USER_EXIST = "user exists"
    static let MESSAGE_INVALID_DATA = "invalid data"
    static let MESSAGE_INVALID_CREDENTIAL = "invalid credential"
    
    func ACCOUNT_UPDATE(mobile: String) -> String {
        return Constants.ACCOUNT + "/\(mobile)"
    }
    func ACCOUNT_INFO(mobile: String, token: String) -> String{
        return Constants.ACCOUNT + "/\(mobile)" + "?token=\(token)"
    }
    func ORDER_URL(mobile: String) -> String{
        return Constants.ORDER + "/\(mobile)"
    }
    func COUPON_URL(coupon: String) -> String{
        return Constants.COUPON + "/\(coupon)"
    }
    func DISCOUNT_TEXT(discount: Double, price: Double) -> String {
        return "-\(discount*100)% You Save \(AppFunc().decimalNum(price))"
    }
    func ORDER_HISTORY(mobile: String) -> String{
        return Constants.ACCOUNT + "/\(mobile)/orders"
    }
   
}
struct Keys{
    static let userinfo = "userinfor"
    static let firstname = "firstnamekey"
    static let lastname = "lastnamekey"
    static let token = "tokenkey"
    static let expdate = "expdatekey"
    static let address = "addresskey"
    static let birthday = "birthdaykey"
    static let mobile = "mobilekey"
    static let email = "emailkey"
    static let orderhistory = "orderhistory"
}