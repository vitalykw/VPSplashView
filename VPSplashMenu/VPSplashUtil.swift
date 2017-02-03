//
//  VPSplashUtil.swift
//  VPSplashMenu
//
//  Created by Vitalii Popruzhenko on 12.05.16.
//  Copyright © 2016 VP. All rights reserved.
//

import Foundation
import UIKit



extension UIColor {
    static func colorWithRedValue(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}

extension UIImage {
    func imageWithColor(_ newColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        newColor.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        return newImage
    }
}

class LiquidHelper {
    static func radToDeg(_ rad: CGFloat) -> CGFloat {
        return rad * 180 / CGFloat(M_PI)
    }
    
    static func degToRad(_ deg: CGFloat) -> CGFloat {
        return deg * CGFloat(M_PI) / 180
    }
    
    static func circlePoint(_ center: CGPoint, radius: CGFloat, rad: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(rad)
        let y = center.y + radius * sin(rad)
        return CGPoint(x: x, y: y)
    }
    
    static func distanceBetween(_ point: CGPoint, point2: CGPoint) -> CGFloat {
        return hypot(point2.x-point.x, point2.y-point.y)
    }
    
    static func circleConnectedPoint(_ circleCenter: CGPoint, circleRadius: CGFloat, otherCenter: CGPoint, angle: CGFloat) -> (CGPoint, CGPoint) {
        let vector = CGPoint(x: otherCenter.x - circleCenter.x, y: otherCenter.y - circleCenter.y)
        let radian = atan2(vector.y, vector.x)
        let p1 = circlePoint(circleCenter, radius: circleRadius, rad: (radian + angle))
        let p2 = circlePoint(circleCenter, radius: circleRadius, rad: (radian - angle))
        return (p1, p2)
    }
    
    
    static func pathBetween(_ circleCenter: CGPoint, circleRadius: CGFloat, otherCenter: CGPoint, otherRadius: CGFloat) -> UIBezierPath{
        
        // Bezier Drawing
        let bezierPath = UIBezierPath()
        let (endFirst, startFirst) = circleConnectedPoint(circleCenter,
                                                          circleRadius: circleRadius,
                                                          otherCenter: otherCenter,
                                                          angle: degToRad(35))
        
        let (startSecond, endSecond) = circleConnectedPoint(otherCenter,
                                                            circleRadius: otherRadius,
                                                            otherCenter: circleCenter,
                                                            angle: degToRad(35))
        
        let (a1,a2) = circleConnectedPoint(circleCenter,
                                           circleRadius: circleRadius,
                                           otherCenter: otherCenter,
                                           angle: degToRad(10))
        
        let (b1,b2) = circleConnectedPoint(otherCenter,
                                           circleRadius: otherRadius,
                                           otherCenter: circleCenter,
                                           angle: degToRad(10))
        
        let c1 = CGPoint(x: (a2.x+b1.x)/2, y: (a2.y+b1.y)/2)
        let c2 = CGPoint(x: (a1.x+b2.x)/2, y: (a1.y+b2.y)/2)
        
        bezierPath.move(to: startFirst)
        bezierPath.addCurve(to: startSecond, controlPoint1: startFirst, controlPoint2: c1)
        bezierPath.addLine(to: endSecond)
        bezierPath.addCurve(to: endFirst, controlPoint1: endSecond, controlPoint2: c2)
        bezierPath.addLine(to: startFirst)
        
        bezierPath.close()
        return bezierPath
    }
    
}
