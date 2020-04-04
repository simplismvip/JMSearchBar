//
//  Extension.swift
//  Extension
//
//  Created by JunMing on 2019/10/11.
//  Copyright © 2019 JMZhao. All rights reserved.
//

import UIKit

extension CGRect {
    static func se_Rect(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension UIColor {
    open class func RGBA(_ R:Int, _ G:Int, _ B:Int, _ A:CGFloat) ->UIColor{
        return UIColor(red: CGFloat(Float(R) / 255.0), green: CGFloat(Float(G) / 255.0), blue: CGFloat(Float(B) / 255.0), alpha: A)
    }
    
    open class func RGB(_ R:Int, _ G:Int, _ B:Int) ->UIColor{
        return UIColor.RGBA(R,G,B,1)
    }
    
    open class var randColor: UIColor {
        let R = Int(arc4random_uniform(256))
        let G = Int(arc4random_uniform(256))
        let B = Int(arc4random_uniform(256))
        return RGB(R,G,B)
    }
}

extension UIFont {
    var se_medium:UIFont {
        return UIFont(name: "PingFangSC-Medium", size: 23)!
    }
    
    open class func se_regular(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Regular", size: size)
    }
    
    open class func se_medium(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: size)
    }
    
    open class func se_Bold(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: size)
    }
    
}

extension UIView {
    var x:CGFloat {
        get {
            return self.frame.origin.x
        }
        set (newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
    }
    
    var y:CGFloat {
        get {
            return self.frame.origin.y;
        }
        set (newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame;
        }
    };
    
    var width:CGFloat {
        get {
            return self.frame.size.width;
        }
        set (newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame;
        }
        
    };
    
    var height:CGFloat {
        get {
            return self.frame.size.height;
        }
        set (newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    };
    
    var size:CGSize {
        get {
            return self.frame.size;
        }
        set (newSize) {
            var frame = self.frame
            frame.size = newSize
            self.frame = frame
        }
    };
    
    var origin:CGPoint {
        get {
            return self.frame.origin;
        }
        set (newOrigin) {
            var frame = self.frame
            frame.origin = newOrigin
            self.frame = frame
        }
    };
    
    var centerX:CGFloat {
        get {
            return self.center.x;
        }
        set (newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    };
    
    var centerY:CGFloat {
        get {
            return self.center.y;
        }
        set (newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    };
    
    var maxX:CGFloat {
        get {
            return self.x+self.width;
        }
        set (newMaxX) {
            var temp = self.frame
            temp.origin.x = newMaxX-self.width
            self.frame = temp
        }
    };
    
    var maxY:CGFloat {
        get {
            return self.y+self.height;
        }
        set (newMaxY) {
            var temp = self.frame
            temp.origin.x = newMaxY-self.height
            self.frame = temp
        }
    };
}
