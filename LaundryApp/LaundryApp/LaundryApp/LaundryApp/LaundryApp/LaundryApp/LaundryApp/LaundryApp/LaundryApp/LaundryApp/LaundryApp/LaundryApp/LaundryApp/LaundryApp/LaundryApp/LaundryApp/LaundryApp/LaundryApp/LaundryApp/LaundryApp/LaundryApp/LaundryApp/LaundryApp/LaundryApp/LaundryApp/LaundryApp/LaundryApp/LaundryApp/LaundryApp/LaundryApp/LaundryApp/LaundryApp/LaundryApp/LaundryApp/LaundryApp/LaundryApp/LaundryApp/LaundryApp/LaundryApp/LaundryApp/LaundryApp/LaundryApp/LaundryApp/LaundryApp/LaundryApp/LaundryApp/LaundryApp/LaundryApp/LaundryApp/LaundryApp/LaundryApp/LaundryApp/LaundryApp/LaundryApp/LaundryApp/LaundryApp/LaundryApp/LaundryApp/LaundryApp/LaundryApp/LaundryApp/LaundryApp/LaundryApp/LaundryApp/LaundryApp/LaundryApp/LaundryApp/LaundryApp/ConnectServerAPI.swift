//
//  ConnectServerAPI.swift
//  LaundryApp
//
//  Created by ZoZy on 7/30/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import Foundation

class ConnectServerAPI{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func POST(params: AnyObject,url: String) -> AnyObject?{
        var Message = ""
        var url = url
        let myUrl = NSURL(string: Constants.SERVER_URL + url)
        println(myUrl)
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let postString = AppFunc().getjsonString(params)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        var response: NSURLResponse?
        var error: NSError?
        if let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error) {
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(urlData, options: NSJSONReadingOptions(0), error: nil)
            println(jsonResult)
            return jsonResult
        }
        return nil
    }
    func GET(url: String) -> AnyObject?{
        var datajson = Array<AnyObject>()
        let myUrl = NSURL(string: Constants.SERVER_URL + url)
                println(myUrl)
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "GET";
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var response: NSURLResponse?
        var error: NSError?
        let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions(0), error: nil)
        return jsonResult
    }
}
