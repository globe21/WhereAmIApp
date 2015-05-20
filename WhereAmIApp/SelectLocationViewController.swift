//
//  SelectLocationViewController.swift
//  WhereAmIApp
//
//  Created by Uğur on 20/05/15.
//  Copyright (c) 2015 ceuur. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SelectLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var myMap: MKMapView!
    
    let locationManager = CLLocationManager()
    var locationText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    dispatch_async(dispatch_get_main_queue()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            
            
            let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
            longPress.minimumPressDuration = 1.0
            self.myMap.addGestureRecognizer(longPress)
       
        
  
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
            let currentCoord = CLLocationCoordinate2D(latitude: manager.location.coordinate.latitude, longitude: manager.location.coordinate.longitude)
            let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(currentCoord, theSpan)
            self.myMap.setRegion(theRegion, animated: true)
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                
                self.displayLocationInfo(pm, location: manager.location)

            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?, location: CLLocation) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            self.locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            
            locationText = locality + " " + postalCode + " " + administrativeArea + " " + country
            
            var newAnotation = MKPointAnnotation()
            newAnotation.coordinate = location.coordinate
            newAnotation.title = country
            newAnotation.subtitle = administrativeArea
            self.myMap.removeAnnotations(self.myMap.annotations)
            self.myMap.addAnnotation(newAnotation)
            
        }
        
    }

    
    func action(gestureRecognizer:UIGestureRecognizer) {
        var touchPoint = gestureRecognizer.locationInView(self.myMap)
        var newCoord:CLLocationCoordinate2D = myMap.convertPoint(touchPoint, toCoordinateFromView: self.myMap)
        
        var newAnotation = MKPointAnnotation()
        newAnotation.coordinate = newCoord
        
        var loc = CLLocation(latitude: newCoord.latitude, longitude: newCoord.longitude)
        
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: { (placemarks, e) -> Void in
            if let error = e {
                println("Error:  (e.localizedDescription)")
            } else {
                if placemarks.count > 0 {

                let placemark = placemarks[0] as! CLPlacemark
                    
                let locality = (placemark.locality != nil) ? placemark.locality : ""
                let postalCode = (placemark.postalCode != nil) ? placemark.postalCode : ""
                let administrativeArea = (placemark.administrativeArea != nil) ? placemark.administrativeArea : ""
                let country = (placemark.country != nil) ? placemark.country : ""
                
                self.locationText = locality + " " + postalCode + " " + administrativeArea + " " + country

                var newAnotation = MKPointAnnotation()
                newAnotation.coordinate = newCoord
                newAnotation.title = country
                newAnotation.subtitle = administrativeArea
                self.myMap.removeAnnotations(self.myMap.annotations)
                self.myMap.addAnnotation(newAnotation)
                }
            }
        })
        
        
    }

    @IBAction func addPinToCurrentLoc(sender: AnyObject) {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    @IBAction func backAction(sender: AnyObject) {
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setObject(locationText, forKey: "USERLOC")
        prefs.synchronize()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
