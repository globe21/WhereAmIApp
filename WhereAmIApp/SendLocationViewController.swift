//
//  SendLocationViewController.swift
//  WhereAmIApp
//
//  Created by Uğur on 17/05/15.
//  Copyright (c) 2015 ceuur. All rights reserved.
//

import UIKit
import CoreLocation

class SendLocationViewController: UIViewController, CLLocationManagerDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var btnSendImage: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var fbBtn = FBSDKMessengerShareButton.circularButtonWithStyle(.Blue)
        fbBtn.addTarget(self, action: "_shareButtonPressed:" , forControlEvents: .TouchUpInside)
//        fbBtn.sizeThatFits(CGSize(width: 200, height: 45))
        //setting for fbBtn if needed
        self.btnSendImage.addSubview(fbBtn)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        lblMessage.hidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""

            lblMessage.text = "Hey! I' am at " + locality + " " + postalCode + " " + administrativeArea + " " + country
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    @IBAction func _shareButtonPressed(sender: AnyObject) {
        let result = FBSDKMessengerSharer.messengerPlatformCapabilities().rawValue & FBSDKMessengerPlatformCapability.Image.rawValue
        if result != 0 {
                lblMessage.hidden = false
            UIGraphicsBeginImageContext(CGSize(width: 360, height: 40))
            messageView.layer.renderInContext(UIGraphicsGetCurrentContext())
            let sharingImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            //  UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            if sharingImage != nil {
                FBSDKMessengerSharer.shareImage(sharingImage, withOptions: nil)
                 lblMessage.hidden = true
            }
        } else {
            // not installed then open link. Note simulator doesn't open iTunes store.
            UIApplication.sharedApplication().openURL(NSURL(string: "itms://itunes.apple.com/us/app/facebook-messenger/id454638411?mt=8")!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                self.performSegueWithIdentifier("send_loc", sender: self)
            }
            
          //  self.returnUserData()
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
        self.navigationController?.popViewControllerAnimated(true)
    }


}
