//
//  TableViewController.swift
//  ForceSplash
//
//  Created by Vitalii Popruzhenko on 13.05.16.
//  Copyright © 2016 VP. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController, MenuDelegate, MenuDataSource{
    var container : VPSplashView?
    
    let menuItems = [[  VPSplashNameKey:"Profile",
                        VPSplashIconKey:"avatar"],
                     [VPSplashNameKey:"Calendar",
                        VPSplashIconKey:"calendar"],
                     [VPSplashNameKey:"Clock",
                        VPSplashIconKey:"clock"],
                     [VPSplashNameKey:"Send",
                        VPSplashIconKey:"paperplane"],
                     [VPSplashNameKey:"Messages",
                        VPSplashIconKey:"email-open"],
                     [VPSplashNameKey:"Share",
                        VPSplashIconKey:"network"]]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        container = VPSplashView.addSplashTo(self.view, menuDelegate: self)
        container?.menu?.secondColor = UIColor.yellowColor()
        container?.menu?.menuIcon = UIImage(named: "rocket")
        container!.setDataSource(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    /*
        This is how it can be done if yo set dataSource, otherwise check example in ViewController
     */
    
    // MARK: Menu Delegate
    
    func pickedItemAtIndex(indexPath : NSIndexPath){
        print("Navigate to \((menuItems[indexPath.row][VPSplashNameKey])!)")
        if (indexPath.row == menuItems.count-1){
            self.performSegueWithIdentifier("Share", sender: nil)
        } else {
            self.navigationItem.title = (menuItems[indexPath.row][VPSplashNameKey])!
        }
    }
    
    // MARK: Menu DataSource
    
    func numberOfMenuItems() -> Int {
        return self.menuItems.count
    }
    
    func menuIconForIndexPath(indexPath: NSIndexPath) -> UIImage {
        return UIImage(named:self.menuItems[indexPath.row][VPSplashIconKey]!)!
    }
}
