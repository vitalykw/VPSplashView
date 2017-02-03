//
//  VPSplashMenu.swift
//  VPSplashMenu
//
//  Created by Vitalii Popruzhenko on 12.05.16.
//  Copyright © 2016 VP. All rights reserved.
//

import Foundation
import UIKit

let VPSplashIconKey = "VPSplashMenuIconKey"
let VPSplashNameKey = "VPSplashMenuNameKey"
// Minimal required force to show items
let minimalForceToSquash:CGFloat = 6.0

protocol MenuDataSource {
    func menuIconForIndexPath(_ indexPath : IndexPath) -> UIImage
    func numberOfMenuItems() -> Int
}

protocol MenuDelegate {
    func pickedItemAtIndex(_ indexPath : IndexPath)
}

class VPSplashMenu : UIView{
    
    // MARK: Settings
    
    // Color of splash and circles
    var mainColor = UIColor.colorWithRedValue(redValue: 0, greenValue: 176, blueValue: 240, alpha: 1.0) {
        didSet {
            self.setup()
        }
    }
    // Tint color of icons
    var secondColor : UIColor = UIColor.white{
        didSet {
            self.setup()
        }
    }

    //Menu icon
    var menuIcon : UIImage? {
        didSet {
            self.mainCircle?.icon = self.menuIcon
            self.mainCircle?.imageScaleFactor = 0.6
        }
    }
    
    //Scale factor for Icon
    let iconScaleFactor: CGFloat = 0.7
    
    // Radius for circles positioning
    let menuRadius:CGFloat = 100.0
    
    // Transparency of button while moving
    let menuCircleTransparency:CGFloat = 0.5
    
    
    // Offest for button while moving finger
    let offset = CGPoint(x: 0, y: -20)
    
    // Preffered radius of circles
    let circlesRadius: CGFloat = 40

    // In case you don't need data source - predefine values here
    let staticDataSource = [[VPSplashNameKey:"Facebook",
                            VPSplashIconKey:"fb"],
                            [VPSplashNameKey:"Twitter",
                                VPSplashIconKey:"tw"],
                            [VPSplashNameKey:"Google+",
                                VPSplashIconKey:"gp"],
                            [VPSplashNameKey:"LinkedIn",
                                VPSplashIconKey:"li"],
                            [VPSplashNameKey:"E-Mail",
                                VPSplashIconKey:"mail"],
                            [VPSplashNameKey:"Call",
                                VPSplashIconKey:"phone"],
                            [VPSplashNameKey:"RSS",
                                VPSplashIconKey:"rss"]
    ]
    
    // MARK: Properties
    var dataSource : MenuDataSource?
    var delegate : MenuDelegate?
    
    var shown : Bool! = false
    
    var mainCircle: VPSplashCircle!
    
    fileprivate var circles: [VPSplashCircle]!
    
    //MARK: Initialization 
    
    //We're not using it for splash
    required init?(coder aDecoder: NSCoder) {
        fatalError("initWithCoder has not been implemented")
    }
    
    /*
     Init Splash view with params:
        center - central position of Splash
        radius - radius for circles positioning, maximal value from center for central point of any menu item
        color  - main color of menu
    */
    
    init(center: CGPoint, mainIcon: UIImage?=nil) {
        let frame = CGRect(x: center.x - menuRadius, y: center.y - menuRadius, width: menuRadius*2, height: menuRadius*2)
        super.init(frame: frame)
        if (mainIcon != nil){
            self.menuIcon = mainIcon
        }
        setup()
        self.movedTo(center)
    }
    
    // General setup
    fileprivate func setup() {
        
        //Clean up
        self.mainCircle?.removeFromSuperview()
        self.circles?.forEach({ $0.removeFromSuperview() })
        
        //Creating central circle
        self.mainCircle = VPSplashCircle(center:CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2), radius: self.circlesRadius, color: self.mainColor)
        self.mainCircle.tintColor = self.secondColor

        if (self.menuIcon != nil){
            self.mainCircle.icon = self.menuIcon
        }
        
        self.addSubview(self.mainCircle)
    }

    // Create menu items
    func setupItems() -> [VPSplashCircle] {
        return Array (0..<self.numberOfMenuItems()).map { i in
            // Calculating angle
            let angle = CGFloat(i) * CGFloat(M_PI*2) / CGFloat(self.numberOfMenuItems())
            
            // Calculating index of randomness
            let index = 0.6 + (CGFloat((arc4random() % 50)) / 100.0)
            
            // Calculating new radius
            let randomRadius = self.circlesRadius*index
            
            // Calculating distance from center
            let randomDistance = min(max (randomRadius*3, CGFloat(arc4random_uniform(UInt32(self.menuRadius)))), self.menuRadius)
            
            // Creating button with needed center
            let center = LiquidHelper.circlePoint(self.mainCircle.center, radius: randomDistance, rad: angle)
            let button = VPSplashCircle(
                center: center,
                radius: randomRadius,
                color: self.mainColor
            )
            
            // Setting properties
            button.center = self.mainCircle.center
            button.mainRadius = self.mainCircle.radius
            button.angleToCenter = angle
            
            button.tintColor = self.secondColor
            
            if (dataSource == nil){
                let imageName = staticDataSource[i][VPSplashIconKey]!
                button.icon = UIImage(named:imageName)!
            } else {
                button.icon = dataSource?.menuIconForIndexPath(IndexPath(row: i, section: 0))
            }
            
            button.imageScaleFactor = iconScaleFactor
            button.tag = i
            
            self.addSubview(button)
            
            // Creating connection layer
            button.connectionLayer = self.connectionLayerWith(button)
            
            return button
        }
    }
    
    func numberOfMenuItems() -> Int {
        if (self.dataSource != nil){
            return (dataSource?.numberOfMenuItems())!
        } else {
            return staticDataSource.count
        }
    }
    
    // MARK: Gesture Handling
    
    func handleTap(_ touchPoint: CGPoint) {
        if (shown == true){
            self.circles?.forEach({
                let expectedFrame = CGRect(x: $0.expectedCenter.x-$0.bounds.width/2, y: $0.expectedCenter.y-$0.bounds.height/2, width: $0.bounds.width, height: $0.bounds.height)
                if (expectedFrame.contains(touchPoint)){
                    $0.highlight()
                } else {
                     $0.unhighlight()
                }
            })
        }
    }
    
    func cancelTap(){
        self.circles?.forEach({
            if ($0.animated){
                self.delegate?.pickedItemAtIndex(IndexPath(row: $0.tag, section: 0))
            }
        })
    }
    
    // MARK: Drawing mathods
    
    func draw(_ path: UIBezierPath) {
        let layer = CAShapeLayer(layer: self.layer)
        layer.lineWidth = 3.0
        layer.fillColor = self.mainColor.cgColor
        layer.path = path.cgPath
        self.layer.addSublayer(layer)
    }
    
    func connectionLayerWith(_ circle:VPSplashCircle)-> CAShapeLayer{
        let finalPath = LiquidHelper.pathBetween(self.mainCircle.center,
                                                 circleRadius: self.mainCircle.radius,
                                                 otherCenter: circle.center,
                                                 otherRadius: circle.radius)
        
        let layer = CAShapeLayer(layer: self.layer)
        layer.lineWidth = 3.0
        layer.fillColor = self.mainColor.cgColor
        layer.path = finalPath.cgPath
        self.layer.insertSublayer(layer, below: circle.layer)
        
        return layer
    }
    
    // MARK: Actions
    
    func showAt(_ view:UIView){
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
        if (circles != nil){
            self.circles?.forEach({
                $0.cleanup()
            })
        }
        shown = false
        UIView.animate(withDuration: 0.1, animations: {
            view.addSubview(self)
            self.transform = CGAffineTransform.identity
        })
    }
    
    func hide(){
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0);
        }, completion: { finished in
            self.removeFromSuperview()
            self.cancelTap()
            self.shown = false
        }) 
    }
    
    func squash(){
        self.mainCircle.alpha = 1.0
        if (shown == false){
            circles = self.setupItems()
            self.bringSubview(toFront: self.mainCircle)
            self.circles?.forEach({
                $0.animateMove()
                $0.unhighlight()
            })
            shown = true
        }
    }
    
    func movedTo(_ centralPoint:CGPoint){
        self.center.x = centralPoint.x+offset.x
        self.center.y = centralPoint.y+offset.y
        self.mainCircle.alpha = menuCircleTransparency
    }
}
