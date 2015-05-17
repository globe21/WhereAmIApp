//
//  ViewController.swift
//  WhereAmIApp
//
//  Created by Uğur on 17/05/15.
//  Copyright (c) 2015 ceuur. All rights reserved.
//

import UIKit

class LoginWithFBViewController: UIViewController,  FBSDKLoginButtonDelegate {

    @IBOutlet weak var btnSendLocation: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            self.performSegueWithIdentifier("send_loc", sender: self)
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if (FBSDKAccessToken.currentAccessToken() != nil){
            btnSendLocation.hidden = false
        }
        else {
            btnSendLocation.hidden = true
        }
        
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        

    }
    
    @IBAction func sendLocation(sender: AnyObject) {
        self.performSegueWithIdentifier("send_loc", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Facebook Delegate Methods
    
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
            
            self.returnUserData()
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        btnSendLocation.hidden = true
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
            }
        })
    }


}

