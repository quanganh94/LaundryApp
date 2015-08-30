//
//  AppDelegate.swift
//  LaundryApp
//
//  Created by ZoZy on 7/6/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit
import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var Products = Array<ProductItem>()
    var Languages = Array<Language>()
    var Categories = Array<CategoriesItem>()
    var basket:  Array<BasketItem> = []
    var lang_id: Int = 1
    var Home: HomeViewController!
    //    var totalItem: Int = 0
    
    var path = NSBundle.mainBundle().pathForResource("database", ofType: "sqlite")
    var totalbill: Double = 0
    var locale: NSLocale = NSLocale(localeIdentifier: "en")
    var currency = ""
    var userinfo = UserInfo()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        locale = NSLocale(localeIdentifier: "en")
        
        userinfo.LoadData()
        
        // Override point for customization after application launch.
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = (UIColor.whiteColor())
        
        navigationBarAppearace.barTintColor = UIColor(netHex:0x34AADC)
        loadData()
        //        checkAmount()
        self.window?.rootViewController?.view
        if let viewControllers = self.window?.rootViewController?.childViewControllers {
            for viewController in viewControllers {
                if viewController.isKindOfClass(UINavigationController) {
                    for view in viewController.childViewControllers {
                        if view.isKindOfClass(HomeViewController) {
                            Home = view as! HomeViewController
                        } else {
                            println("Not Found Home")
                        }
                    }
                }
            }
        }
        
        let lang: AnyObject? = AppFunc().getNSObject("lang_id")
        if(lang == nil){
            AppFunc().setNSObject(lang_id, key: "lang_id")
            let pre: AnyObject = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)!
            for lang in Languages{
                if(lang.code == pre as! String){
                    NSBundle.setLanguage(lang.code)
                    SetLanguage(lang.lang_id)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
            }
        } else {
            lang_id = lang as! Int
            for lang in Languages{
                if(lang.lang_id == self.lang_id){
                    NSBundle.setLanguage(lang.code)
                    SetLanguage(lang.lang_id)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
            }

        }
        

        return true
    }
    
    func loadData(){
        Products.removeAll()
        let db = Database(path!, readonly: true)
        let stmt = db.prepare("SELECT Products.id, Translation.text, Products.code, Products.price_usd, Products.price_local, Products.image, Products.cat_id FROM Products, Translation WHERE Products.name_id = Translation.id AND Translation.lang_id=\(lang_id)")
        
        for item in stmt{
            let item: ProductItem = ProductItem(ID: "\(item[0]!)".toInt()!,name: "\(item[1]!)", image: "\(item[5]!)", price: "\(item[3]!)".toInt()!, cat_id: "\(item[6]!)".toInt()!, code: "\(item[2]!)", priceVND: "\(item[4]!)".toInt()!)
            Products.append(item)
        }
        Categories.removeAll()
        let cat = db.prepare("SELECT id, code FROM Categories")
        for item in cat {
            let i: CategoriesItem = CategoriesItem(cat_id: "\(item[0]!)".toInt()!, code: "\(item[1]!)")
            Categories.append(i)
        }
        
        Languages.removeAll()
        let lang = db.prepare("SELECT name, id, code, currency FROM Languages")
        for item in lang {
            var currency = ""
            if(item[3] != nil){
                currency = "\(item[3]!)"
            }
            let i: Language = Language(name:"\(item[0]!)", id:"\(item[1]!)".toInt()!, code: "\(item[2]!)", currency: currency )
            Languages.append(i)
        }
    }
    
    func SetLanguage(id: Int){
        if(id != 0 ){
            self.lang_id = id
            AppFunc().setNSObject(id, key: "lang_id")
            updateLanguage()
        } else {
            showAlert("Not found language data", message: "Coming soon")
        }
    }
    
    
    func updateLanguage(){
        let db = Database(path!, readonly: true)
        let stmt = db.prepare("SELECT Products.code, Translation.text FROM Products, Translation WHERE Products.name_id = Translation.id AND Translation.lang_id=\(lang_id)")
        for item in stmt{
            let code = "\(item[0]!)"
            let text = "\(item[1]!)"
            for product in Products {
                if(product.code == code){
                    product.name = text
                }
            }
        }
        for lang in Languages {
            if(lang.lang_id == lang_id){
                NSBundle.setLanguage(lang.code)
                locale = NSLocale(localeIdentifier: lang.code)
                NSUserDefaults.standardUserDefaults().setObject(lang.code, forKey: "AppleLanguages")
                NSUserDefaults.standardUserDefaults().synchronize()
                currency = lang.currency
            }
        }
    }
    
    func addtoBasket(item: ProductItem, am: Int){
        for i in basket {
            if(item.id == i.id){
                if(am == -1 ){
                    item.amount += 1
                } else if(am == 0){
                    let index = findBasketIndex(item.id)
                    if(index != -1){
                        basket.removeAtIndex(index)
                        NSNotificationCenter.defaultCenter().postNotificationName("DeleteRow", object: nil, userInfo: nil)
                    }
                    item.amount = am
                } else {
                    item.amount = am
                }
                i.quantity = item.amount
                checkAmount()
                return
            }
        }
        
        item.amount = 1
        basket.append(BasketItem(id: item.id, quantity: item.amount))
        checkAmount()
    }
    func removefromBasket(item: ProductItem) -> Int{
        for i in basket {
            if(item.id == i.id){
                item.amount -= 1
                if(item.amount==0){
                    let index = findBasketIndex(item.id)
                    if(index != -1){
                        basket.removeAtIndex(index)
                        NSNotificationCenter.defaultCenter().postNotificationName("DeleteRow", object: nil, userInfo: nil)
                    }
                }
                checkAmount()
                i.quantity = item.amount
                return item.amount
            }
        }
        return -1
    }

    func totalItem() -> Int{
        var total = 0
        for i in basket {
            total += i.quantity
        }
        return total
    }
    func checkAmount(){
        let total = totalItem()
        if(total > 0 ){
            Home.lblamount.hidden = false
            if(Home.isViewLoaded() && Home.view.window != nil) {
                let trans :CGAffineTransform = Home.lblamount.transform
                UIView.animateWithDuration(0.15, animations: {
                    self.Home.lblamount.transform = CGAffineTransformMakeScale(1.2,1.2)
                }, completion: { finished in
                        self.Home.lblamount.text = "\(self.totalItem())"
                        // remove the views
                        if finished {
                            UIView.animateWithDuration(0.15, animations: {
                                self.Home.lblamount.transform = trans
                            })
                        }
                })
            }
            else {
                self.Home.lblamount.text = "\(self.totalItem)"
            }
        } else {
            Home.lblamount.hidden = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("Change", object: nil, userInfo: nil)
    }

    
    func findBasketIndex(id: Int) -> Int{
        var count = 0
        for i in self.basket{
            if(i.id == id){
                return count
            }
            count++
        }
        return -1
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title,
            message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(dismissAction)
        
        if let rootViewController = UIApplication.currentViewController() {
            rootViewController.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
extension UIView {
    // Name this function in a way that makes sense to you...
    // slideFromLeft, slideRight, slideLeftToRight, etc. are great alternative names
    func slideInFromLeft(duration: NSTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromLeftTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = kCATransitionFromLeft
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
    }
    
    func slideInFromRight(duration: NSTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromRightTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        if let delegate: AnyObject = completionDelegate {
            slideInFromRightTransition.delegate = delegate
        }
        
        // Customize the animation's properties
        slideInFromRightTransition.type = kCATransitionPush
        slideInFromRightTransition.subtype = kCATransitionFromRight
        slideInFromRightTransition.duration = duration
        slideInFromRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromRightTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        self.layer.addAnimation(slideInFromRightTransition, forKey: "slideInFromRightTransition")
    }
}
extension UIApplication {
    class func currentViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return currentViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
}
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}
