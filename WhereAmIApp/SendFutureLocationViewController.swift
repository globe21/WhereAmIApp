//
//  SendFutureLocationViewController.swift
//  WhereAmIApp
//
//  Created by Uğur on 20/05/15.
//  Copyright (c) 2015 ceuur. All rights reserved.
//

import UIKit

class SendFutureLocationViewController: UIViewController {
    
    @IBOutlet weak var btnSendImage: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var fbBtn = FBSDKMessengerShareButton.circularButtonWithStyle(.Blue)
        fbBtn.addTarget(self, action: "_shareButtonPressed:" , forControlEvents: .TouchUpInside)
        //        fbBtn.sizeThatFits(CGSize(width: 200, height: 45))
        //setting for fbBtn if needed
        self.btnSendImage.addSubview(fbBtn)

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
        }
    }
    
    @IBAction func _shareButtonPressed(sender: AnyObject) {
        let result = FBSDKMessengerSharer.messengerPlatformCapabilities().rawValue & FBSDKMessengerPlatformCapability.Image.rawValue
        if result != 0 {
            lblMessage.hidden = false
            lblMessage.text = lblLocation.text
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
