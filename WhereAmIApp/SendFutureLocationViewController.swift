//
//  SendFutureLocationViewController.swift
//  WhereAmIApp
//
//  Created by Uğur on 20/05/15.
//  Copyright (c) 2015 ceuur. All rights reserved.
//

import UIKit

class SendFutureLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnSendImage: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var txtDate: UITextField!
    
    var isPlaceSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var buttonWidth = CGFloat(80)
        var fbBtn = FBSDKMessengerShareButton.circularButtonWithStyle(.Blue,  width:buttonWidth)
        fbBtn.addTarget(self, action: "_shareButtonPressed:" , forControlEvents: .TouchUpInside)
        //        fbBtn.sizeThatFits(CGSize(width: 200, height: 45))
        //setting for fbBtn if needed
        self.btnSendImage.addSubview(fbBtn)
        
        self.txtDate.delegate = self
        datePicker.backgroundColor = UIColor(red: 42, green: 140, blue: 162, alpha: 1)
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        // Do any additional setup after loading the view.
    }
 
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        lblMessage.hidden = true
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if let locationText = prefs.valueForKey("USERLOC") as? String{
            
            lblLocation.text = locationText
            lblMessage.text = locationText
            let appDomain = NSBundle.mainBundle().bundleIdentifier
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
            
            isPlaceSelected = true
        }
    }
    
    @IBAction func _shareButtonPressed(sender: AnyObject) {
        if isPlaceSelected && txtDate.text != ""{
        let result = FBSDKMessengerSharer.messengerPlatformCapabilities().rawValue & FBSDKMessengerPlatformCapability.Image.rawValue
        if result != 0 {
            lblMessage.hidden = false
            lblMessage.text = "Hey! I will be at " + lblLocation.text! + " at " + self.txtDate.text
            UIGraphicsBeginImageContext(CGSize(width: 360, height: 80))
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
        else{
            let alertController = UIAlertController(title: "WhereAmIApp", message: "Please select a date and location", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        }
    }

    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        txtDate.text = strDate
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        
        if textField === txtDate {
            txtDate.resignFirstResponder()
            datePicker.hidden = false
            toolBar.hidden = false
            btnSendImage.hidden = true
            return false
        }
        return   true
    }
    
    @IBAction func hideDatePicker(sender: AnyObject) {
        datePicker.hidden = true
        toolBar.hidden = true
        btnSendImage.hidden = false
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
