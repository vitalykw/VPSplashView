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
        splashMenu.menu?.mainColor = UIColor.red
        splashMenu.menu?.secondColor = UIColor.white
        splashMenu.menu?.menuIcon = UIImage(named: "share")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Menu Delegate
    
    /*
        This is how it can be done if won't set dataSource and would like to define staticDataSource in VPSplashMenuSettings
     */
    
    func pickedItemAtIndex(_ indexPath : IndexPath){
        switch indexPath.row {
        case 0:
            self.postToFacebook()
        case 1:
            self.postToTwitter()
        default:
            let alertController = UIAlertController(title: "Test action", message:"Share something", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style:.default, handler: { action in
                //Share
            }))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func postToTwitter(){
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let tweet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweet?.setInitialText("Check out this cool component: https://github.com/vitalykw/VPSplashView by Vitalii Popruzhenko")
            self.present(tweet!, animated: true, completion: nil)
        }
    }
    
    func postToFacebook(){
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let fbPost = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbPost?.setInitialText("Check out this cool component: https://github.com/vitalykw/VPSplashView by Vitalii Popruzhenko")
            self.present(fbPost!, animated: true, completion: nil)
        }
    }
}

