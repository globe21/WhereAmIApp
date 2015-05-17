//
//  SendLocationViewController.swift
//  WhereAmIApp
//
//  Created by Uğur on 17/05/15.
//  Copyright (c) 2015 ceuur. All rights reserved.
//

import UIKit

class SendLocationViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var btnSendImage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        
        var fbBtn = FBSDKMessengerShareButton.rectangularButtonWithStyle(.Blue)
        fbBtn.addTarget(self, action: "_shareButtonPressed:" , forControlEvents: .TouchUpInside)
        //setting for fbBtn if needed
        self.btnSendImage.addSubview(fbBtn)
        
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            // User is already logged in, do work such as go to next view controller.
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//        else
//        {
//         
//        }
    }

    @IBAction func _shareButtonPressed(sender: AnyObject) {
        let result = FBSDKMessengerSharer.messengerPlatformCapabilities().rawValue & FBSDKMessengerPlatformCapability.Image.rawValue
        if result != 0 {
            // ok now share
            let sharingImage = UIImage(named: "me.jpg")
            if sharingImage != nil {
                FBSDKMessengerSharer.shareImage(sharingImage, withOptions: nil)
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
