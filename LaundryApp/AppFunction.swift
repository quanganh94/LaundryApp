//
//  FunctionProcessing.swift
//  LaundryApp
//
//  Created by ZoZy on 8/18/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import Foundation

class AppFunc{

    func getDateFromString(date: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "us")
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        var d: NSDate! = dateFormatter.dateFromString(date)
        return d
    }
    func setNSObject(object: AnyObject, key: String){
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: key)
    }
    func getNSObject(key: String) -> AnyObject?{
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    func getjsonString(content: AnyObject) -> String{
        var string = ""
        var error : NSError?
        if let jsonData = NSJSONSerialization.dataWithJSONObject(content, options: nil, error: &error) {
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
            println(jsonString)
            string = jsonString
        } else {
            println("Error in JSON conversion: \(error!.localizedDescription)")
        }
        return string
    }

    func decimalNum(number: AnyObject) -> String{
        return "\(numberFormat().stringFromNumber(number as! NSNumber)!)"
    }
    func numberFormat() -> NSNumberFormatter{
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        return formatter
    }
    func checkPhone(number: String) -> Bool{
        if(count(number) >= 10 ) {
            return true
        }
        return false
    }
    
    // Keyboard constant
    var keyboarHeight: CGFloat = 180
    var MINIMUM_SCROLL_FRACTION: CGFloat = 0.2;
    var MAXIMUM_SCROLL_FRACTION: CGFloat = 0.8;
    func PushUpKeyboard(view: UIView, textField: UITextField, originalFrame: CGRect){
        var textFieldRect: CGRect = view.window!.convertRect(textField.bounds, fromView: textField)
        if(true) {
            var viewRect: CGRect = view.window!.convertRect(view.bounds, fromView: view)
            let midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height
            let numerator =
            midline - viewRect.origin.y
                - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
            let denominator =
            (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
                * viewRect.size.height;
            var heightFraction = numerator / denominator
            
            if (heightFraction < 0.0)
            {
                heightFraction = 0.0;
            }
            else if (heightFraction > 1.0)
            {
                heightFraction = 1.0;
            }
            var animatedDistance = floor(keyboarHeight * heightFraction)
            var viewFrame = originalFrame
            viewFrame.origin.y -= animatedDistance
            UIView.animateWithDuration(0.3, animations: {
                view.frame = viewFrame
            })
        }
    }
}