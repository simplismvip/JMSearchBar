//
//  Extension.swift
//  Extension
//
//  Created by JunMing on 2019/10/11.
//  Copyright © 2019 JMZhao. All rights reserved.
//

import UIKit

extension CGRect {
    static func Rect(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) -> CGRect {
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
    var medium:UIFont {
        return UIFont(name: "PingFangSC-Medium", size: 23)!
    }
    
    open class func regular(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Regular", size: size)
    }
    
    open class func medium(_ size:CGFloat) -> UIFont? {
        return UIFont(name: "PingFangSC-Medium", size: size)
    }
    
    open class func Bold(_ size:CGFloat) -> UIFont? {
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

extension UIView {
    func screenCapture() -> UIImage? {
        let scale = UIScreen.main.scale
        let width = bounds.size.width*scale
        let height = bounds.size.height*scale
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        layer.render(in: ctx!)
        
        let inImageRef = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        guard let outImageRef = inImageRef?.cropping(to:CGRect.Rect(0, 0, width, height)) else {
            return nil
        }
        
        let nImage = UIImage(cgImage:outImageRef)
        UIGraphicsEndImageContext()
        return nImage
    }
    
    // 切圆角，可自定义切哪个角
    // [.topLeft, .topRight]
    func rectCorner(by corners:UIRectCorner = [.topLeft, .topRight]) {
        let shaper = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 20, height: 20))
        shaper.path = path.cgPath
        layer.mask = shaper
    }
    
    /// 获取当前展示的Controller
    func fristShowView() -> UIView? {
        guard let window = UIApplication.shared.delegate?.window else {
            return nil
        }
        
        guard var topVC = window?.rootViewController else {
            return nil
        }
        
        while true {
            if let newVc = topVC.presentedViewController {
                topVC = newVc
            }else if topVC.isKind(of: UINavigationController.self) {
                let navVC = topVC as! UINavigationController
                if let topNavVC = navVC.topViewController {
                    topVC = topNavVC
                }
            }else if topVC.isKind(of: UITabBarController.self) {
                let tabVC = topVC as! UITabBarController
                if let selTabVC = tabVC.selectedViewController {
                    topVC = selTabVC
                }
            }else{
                break
            }
        }
        return topVC.view
    }
}

protocol ControllerProtocol:UIViewController {}
extension ControllerProtocol {}

extension UIViewController {
    func showAlert(_ title:String?, _ msg:String?, _ placeHolder:String, handler:((_ toast:String?)->())?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
            if let text = alert.textFields?.first?.text {
                if let handle = handler { handle(text) }
            }else{
                self.showAlert("请重新输入", "输入为空", false, nil)
            }
        }
        alert.addTextField { textField in
            textField.text = placeHolder
            textField.textColor = UIColor.gray
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.borderStyle = UITextField.BorderStyle.roundedRect
        }
        
        let cancleAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(sureAction)
        alert.addAction(cancleAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ title:String?, _ msg:String?, _ showCancle:Bool, _ handler:((_ toast:String?)->())?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let sureAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
            if let handle = handler { handle(nil) }
        }
        if showCancle {
            let cancleAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancleAction)
        }
        alert.addAction(sureAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func shareImageToFriends(shareID:String?,image:UIImage?,completionHandler:@escaping (_ activityType:UIActivity.ActivityType?, _ completed:Bool?)->()) {
        var items = [Any]()
        if let appname = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            items.append("#\(appname)#")
        }
        if let share = shareID { items.append(share) }
        if let ima = image { items.append(ima) }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        let excludedActivityTypes = [UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.print, UIActivity.ActivityType.postToTencentWeibo, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.message]
        activityVC.excludedActivityTypes = excludedActivityTypes
        activityVC.completionWithItemsHandler = { activity, completed, items, error in
            completionHandler(activity,completed)
        }
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = self.navigationController?.navigationBar
                popover.sourceRect = (self.navigationController?.navigationBar.bounds)!
                popover.permittedArrowDirections = .up
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
}
