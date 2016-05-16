//
//  VPSplashView.swift
//  VPSplashMenu
//
//  Created by Vitalii Popruzhenko on 12.05.16.
//  Copyright © 2016 VP. All rights reserved.
//

import Foundation
import UIKit

class VPSplashView : UIView {
    
    static func addSplashTo(view : UIView, menuDelegate: MenuDelegate) -> VPSplashView{
        let splashView = VPSplashView(view: view)
        splashView.backgroundColor = UIColor.clearColor()
        splashView.exclusiveTouch = true
        
        if (view.isKindOfClass(UIScrollView.classForCoder())){
            (view as! UIScrollView).canCancelContentTouches = false
        }
        
        splashView.menu?.delegate = menuDelegate
        return splashView
    }
    
    // MARK: Initialization
    var menu : VPSplashMenu?
    
    private var use3DTouch : Bool = true
    
    var onceToken: dispatch_once_t = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(view: UIView){
        super.init(frame:view.bounds)
        view.addSubview(self)
        self.menu = VPSplashMenu.init(center: self.center)
    }
    
    func setDataSource(source: MenuDataSource!){
        self.menu?.dataSource = source
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        self.superview?.bringSubviewToFront(self)

        if (self.superview != nil){
            self.setup()
        }
    }
    
    private func setup(){
        dispatch_once(&onceToken) {
            if self.traitCollection.forceTouchCapability == UIForceTouchCapability.Unavailable
            {
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(VPSplashView.longPressed(_:)))
                self.addGestureRecognizer(longPressRecognizer)
                self.use3DTouch = false
            } else {
                self.use3DTouch = true
            }
        };
    }
    
    // MARK: Long Press Handling
    func longPressed(sender: UILongPressGestureRecognizer)
    {
        switch sender.state {
        case .Began:
            let centerPoint  = sender.locationInView(self)
            menu?.movedTo(centerPoint)
            menu?.showAt(self)
            menu?.squash()
            
        case .Ended:
            menu?.cancelTap()
            menu?.removeFromSuperview()
        case .Changed:
            let centerPoint = sender.locationInView(self)
            menu?.handleTap((menu?.convertPoint(centerPoint, fromView: self))!)
        default:
            menu?.removeFromSuperview()
        }
    }
    
    // MARK: Touch Handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (use3DTouch == true){
            var centerPoint : CGPoint = CGPointZero
            for touch in touches {
                centerPoint = touch.locationInView(self)
                menu?.movedTo(centerPoint)
                menu?.showAt(self)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (use3DTouch == true){
            for touch in touches {
                let centerPoint = touch.locationInView(self)
                if (menu?.shown == false){
                    menu?.movedTo(centerPoint)
                    if (touch.force > minimalForceToSquash){
                        menu?.squash()
                    }
                } else {
                    menu?.handleTap((menu?.convertPoint(centerPoint, fromView: self))!)
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (use3DTouch == true){
            menu?.hide()
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        if (use3DTouch){
            menu?.hide()
        }
    }
}