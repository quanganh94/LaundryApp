//
//  SettingViewController.swift
//  LaundryApp
//
//  Created by ZoZy on 7/17/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var langPicker: UIPickerView!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var setLang: Int = -1
    
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewWillAppear(animated: Bool) {
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]

        var index = 0
        for i in appDelegate.Languages {
            if(i.lang_id == appDelegate.lang_id){
                langPicker.selectRow(index, inComponent: 0, animated: false)
            }
            index++
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appDelegate.Languages.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return appDelegate.Languages[row].name
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setLang = appDelegate.Languages[row].lang_id
    }
    
    @IBAction func Save(sender: AnyObject) {
        if(setLang != -1){
            self.appDelegate.SetLanguage(setLang)
        }
    }
}
