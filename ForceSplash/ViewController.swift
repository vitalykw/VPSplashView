//
//  ViewController.swift
//  ForceSplash
//
//  Created by Vitalii Popruzhenko on 26.04.16.
//  Copyright © 2016 VP. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, MenuDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        let splashMenu = VPSplashView.addSplashTo(self.view, menuDelegate: self)
        splashMenu.menu?.mainColor = UIColor.redColor()
        splashMenu.menu?.secondColor = UIColor.whiteColor()
        splashMenu.menu?.menuIcon = UIImage(named: "share")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Menu Delegate
    
    /*
        This is how it can be done if won't set dataSource and would like to define staticDataSource in VPSplashMenuSettings
     */
    
    func pickedItemAtIndex(indexPath : NSIndexPath){
        switch indexPath.row {
        case 0:
            self.postToFacebook()
        case 1:
            self.postToTwitter()
        default:
            let alertController = UIAlertController(title: "Test action", message:"Share something", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style:.Default, handler: { action in
                //Share
            }))
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func postToTwitter(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let tweet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweet.setInitialText("Check out this cool component: https://github.com/vitalykw/VPSplashView by Vitalii Popruzhenko")
            self.presentViewController(tweet, animated: true, completion: nil)
        }
    }
    
    func postToFacebook(){
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let fbPost = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbPost.setInitialText("Check out this cool component: https://github.com/vitalykw/VPSplashView by Vitalii Popruzhenko")
            self.presentViewController(fbPost, animated: true, completion: nil)
        }
    }
}

