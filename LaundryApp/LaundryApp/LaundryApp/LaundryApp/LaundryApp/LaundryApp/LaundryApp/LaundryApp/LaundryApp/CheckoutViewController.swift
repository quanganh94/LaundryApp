//
//  CheckoutViewController.swift
//  LaundryApp
//
//  Created by ZoZy on 7/22/15.
//  Copyright (c) 2015 ZoZy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CheckoutViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    // Connect outlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnLocate: UIButton!
    @IBOutlet weak var addLine1: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var PlaceOrderBtn: UIButton!
    @IBOutlet weak var collectionDP: UIDatePicker!
    @IBOutlet weak var deliverDP: UIDatePicker!
    
    //------
    
    // Keyboard constant
    var keyboarHeight: CGFloat = 180
    var MINIMUM_SCROLL_FRACTION: CGFloat = 0.2;
    var MAXIMUM_SCROLL_FRACTION: CGFloat = 0.8;
    var originFrame: CGRect!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // Search location------
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    // -------------
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var coupon = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        btnLocate.selected = true
        //        zoomIn(self.mapView.userLocation.coordinate)
        // Do any additional setup after loading the view.
        //
        //        var mapRegion = MKCoordinateRegion()
        //        mapView.setRegion(mapRegion, animated: true)
        
        addLine1.delegate = self
        originFrame = self.view.frame
        
        var numberToolbar: UIToolbar = UIToolbar(frame: CGRectMake(self.view.frame.width/2-10, 0, self.view.frame.width, 50))
        let doneButton = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        doneButton.addTarget(self, action: "dismissNumberPad", forControlEvents: UIControlEvents.TouchUpInside)
        
        doneButton.backgroundColor = UIColor(netHex:0x34AADC)
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitle("Done", forState: UIControlState.Highlighted)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        numberToolbar.addSubview(doneButton)
        
        phoneNum.inputAccessoryView = numberToolbar
        setupDatePicker()
        fullName.text = "\(appDelegate.userinfo.firstname) \(appDelegate.userinfo.lastname)"
        phoneNum.text = "\(appDelegate.userinfo.mobile)"
    }
    
    @IBAction func placeOrder(sender: AnyObject) {
        prepareForOrder()
        
    }
    
    func prepareForOrder(){
        let token = self.appDelegate.userinfo.token
        if token != "" {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            var items = Array<AnyObject>()
            for i in appDelegate.basket{
                let item = ["productcode":i.id, "quantity":i.quantity] as Dictionary<String, Int>
                items.append(item)
            }
            println(items.count)
            if (items.count > 0){
                
                let pickup = dateFormatter.stringFromDate(collectionDP.date)
                let delivery = dateFormatter.stringFromDate(collectionDP.date)
                
                var contact : [String: AnyObject] = [:]
                contact["mobile"] = phoneNum.text
                contact["name"] = fullName.text
                contact["address"] = addLine1.text
                contact["email"] = appDelegate.userinfo.email
                
                var content : [String: AnyObject] = [:]
                content["pickup"] = pickup
                content["delivery"] = delivery
                content["coupon"] = self.coupon
                content["note"] = "abc"
                content["items"] = items
                content["contact"] = contact
                content["currency"] = appDelegate.currency
                
                var data : [String: AnyObject] = [:]
                data["content"] = content
                data["token"] = token
                
                let CN = ConnectServerAPI()
                
                let alert = AlertManager(view: self)
                alert.Wait()
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    var mess = ""
                    if let json: AnyObject = CN.POST(data,url: Constants().ORDER_URL(self.appDelegate.userinfo.mobile)){
                        if(json.valueForKey("status") as! String == Constants.STATUS_SUCCESS){
                            mess = Constants.STATUS_SUCCESS
                        }
                    } else {
                        mess = "SERVER_ERROR".localized
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        alert.dismissWait()
                        if(mess == Constants.STATUS_SUCCESS) {
                            alert.showAlert("SUCCESS".localized, message: "ORDER_SUCESS".localized)
                        } else {
                            alert.showAlert("ERROR".localized, message: mess)
                        }

                    }
                }
            } else {
                AlertManager(view: self).showAlert("CANNOT_ORDER".localized, message: "NO_ITEM".localized)
                
            }
        } else {
            AlertManager(view: self).showAlert("CANNOT_ORDER".localized, message: "MUST_LOGIN".localized)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("Error: " + error.localizedDescription)
                self.locationManager.stopUpdatingLocation()
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                //                    println("Location Found")
                //                    println(pm.subLocality)
                
                self.displayLocationInfo(pm)
                
            } else {
                let alert = UIAlertView(title: nil, message: "CANNOT_LOCATE".localized, delegate: self, cancelButtonTitle: "Dismiss")
                alert.show()
            }
        })
    }
    
    func displayLocationInfo(pm: CLPlacemark){
        currentLocation = pm.location
        self.locationManager.stopUpdatingLocation()
        if let line1 = pm.subThoroughfare{
            var address = ""
            address += line1 + " "
            if let line1s = pm.thoroughfare {
                address += line1s + " "
            }
            if let line2 = pm.subLocality{
                address += line2 + " "
                if let line2s =  pm.subAdministrativeArea {
                    address += line2s + " "
                }
            }
            if let line3 = pm.administrativeArea{
                address += line3 + " "
                if let line3s =  pm.country {
                    address += line3s + " "
                }
            }
            addLine1.text = address
        }
        mapView.setCenterCoordinate(currentLocation.coordinate, animated: true)
        zoomIn(currentLocation.coordinate)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
        let alert = UIAlertView(title: nil, message: "CANNOT_LOCATE".localized, delegate: self, cancelButtonTitle: "Dismiss")
        alert.show()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
    }
    func zoomIn(coordinate: CLLocationCoordinate2D){
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = coordinate
        mapRegion.span.latitudeDelta = 0.01
        mapRegion.span.longitudeDelta = 0.01
        
        mapView.setRegion(mapRegion, animated: true)
    }
    func zoomOut(coordinate: CLLocationCoordinate2D){
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = coordinate
        mapRegion.span.latitudeDelta = 1
        mapRegion.span.longitudeDelta = 1
        
        mapView.setRegion(mapRegion, animated: true)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        AppFunc().PushUpKeyBoard()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = self.originFrame
        })
        textField.resignFirstResponder()
        if(textField != fullName){
            searchArea()
        }
        
        return false
    }
    
    func dismissNumberPad() {
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = self.originFrame
        })
        phoneNum.resignFirstResponder()
    }
    
    func searchArea(){
        self.zoomOut(self.mapView.userLocation.coordinate)
        btnLocate.selected = false
        self.mapView.showsUserLocation = false
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0] as! MKAnnotation
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = addLine1.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.addLine1.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation)
            self.zoomIn(self.pointAnnotation.coordinate)
            
        }
        
    }
    
    
    func setupDatePicker(){
        let pickup: NSDate = NSDate().dateByAddingTimeInterval(60*60*2)
        let next2day: NSDate = NSDate().dateByAddingTimeInterval(60*60*24*2)
        self.collectionDP.minimumDate = pickup
        self.deliverDP.minimumDate = next2day
    }
    //
    func doneButton(sender:UIButton)
    {
        phoneNum.resignFirstResponder()
    }
    
    @IBAction func locateCurrentLocation(sender: AnyObject) {
        if(btnLocate.selected == false){
            if(self.currentLocation != nil){
                self.mapView.removeAnnotations(self.mapView.annotations)
                btnLocate.selected = true
                self.locationManager.startUpdatingLocation()
                self.mapView.showsUserLocation = true
                self.mapView.setCenterCoordinate(self.mapView.userLocation.coordinate, animated: true)
                self.zoomIn(self.mapView.userLocation.coordinate)
            } else {
                let alert = UIAlertView(title: nil, message: "Cannot locate your location", delegate: self, cancelButtonTitle: "Dismiss")
                alert.show()
            }
        }
    }
    override func viewWillLayoutSubviews() {
        self.scrollView.delegate = self
        self.scrollView.frame = self.view.frame
        self.scrollView.contentSize = CGSizeMake(self.view.frame.width, 800)
        var contentRect = CGRectZero;
        for view in self.scrollView.subviews{
            contentRect = CGRectUnion(contentRect, self.view.frame)
        }
        
        self.view.addSubview(scrollView)
    }
    
    @IBAction func changeCollect(sender: AnyObject) {
        let next2day: NSDate = collectionDP.date.dateByAddingTimeInterval(60*60*24*2)
        deliverDP.minimumDate = next2day
    }
    @IBAction func AccountLocation(sender: AnyObject) {
        addLine1.text = appDelegate.userinfo.address
        searchArea()
        
    }
    
}
