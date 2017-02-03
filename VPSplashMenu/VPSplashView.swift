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
    
    private lazy var __once: () = {
            if self.traitCollection.forceTouchCapability == UIForceTouchCapability.unavailable
            {
                let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(VPSplashView.longPressed(_:)))
                self.addGestureRecognizer(longPressRecognizer)
                self.use3DTouch = false
            } else {
                self.use3DTouch = true
            }
        }()
    
    static func addSplashTo(_ view : UIView, menuDelegate: MenuDelegate) -> VPSplashView{
        let splashView = VPSplashView(view: view)
        splashView.backgroundColor = UIColor.clear
        splashView.isExclusiveTouch = true
        
        if (view.isKind(of: UIScrollView.classForCoder())){
            (view as! UIScrollView).canCancelContentTouches = false
        }
        
        splashView.menu?.delegate = menuDelegate
        return splashView
    }
    
    // MARK: Initialization
    var menu : VPSplashMenu?
    
    fileprivate var use3DTouch : Bool = true
    
    var onceToken: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(view: UIView){
        super.init(frame:view.bounds)
        view.addSubview(self)
        self.menu = VPSplashMenu.init(center: self.center)
    }
    
    func setDataSource(_ source: MenuDataSource!){
        self.menu?.dataSource = source
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        self.superview?.bringSubview(toFront: self)

        if (self.superview != nil){
            self.setup()
        }
    }
    
    fileprivate func setup(){
        _ = self.__once;
    }
    
    // MARK: Long Press Handling
    func longPressed(_ sender: UILongPressGestureRecognizer)
    {
        switch sender.state {
        case .began:
            let centerPoint  = sender.location(in: self)
            menu?.movedTo(centerPoint)
            menu?.showAt(self)
            menu?.squash()
            
        case .ended:
            menu?.cancelTap()
            menu?.removeFromSuperview()
        case .changed:
            let centerPoint = sender.location(in: self)
            menu?.handleTap((menu?.convert(centerPoint, from: self))!)
        default:
            menu?.removeFromSuperview()
        }
    }
    
    // MARK: Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (use3DTouch == true){
            var centerPoint : CGPoint = CGPoint.zero
            for touch in touches {
                centerPoint = touch.location(in: self)
                menu?.movedTo(centerPoint)
                menu?.showAt(self)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (use3DTouch == true){
            for touch in touches {
                let centerPoint = touch.location(in: self)
                if (menu?.shown == false){
                    menu?.movedTo(centerPoint)
                    if (touch.force > minimalForceToSquash){
                        menu?.squash()
                    }
                } else {
                    menu?.handleTap((menu?.convert(centerPoint, from: self))!)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (use3DTouch == true){
            menu?.hide()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (use3DTouch){
            menu?.hide()
        }
    }
}
