//
//  JMSearchExtension.swift
//  eBooks
//
//  Created by JunMing on 2019/11/26.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit

private let JMSearchEmptyViewTag = 12345;
private let onceToken = "JMSearchToken"
private let minimumHitArea = CGSize(width: 44, height: 44)

extension UIImage {
    static func imageNamed(bundleName name:String) -> UIImage? {
        
        func findBundle(_ bundleName:String,_ podName:String) -> Bundle? {
            if var bundleUrl = Bundle.main.url(forResource: "Frameworks", withExtension: nil) {
                bundleUrl = bundleUrl.appendingPathComponent(podName)
                bundleUrl = bundleUrl.appendingPathExtension("framework")
                if let bundle = Bundle(url: bundleUrl),let url = bundle.url(forResource: bundleName, withExtension: "bundle") {
                    return Bundle(url: url)
                }
                return nil
            }
            return nil
        }
                
        if let bundle = findBundle("JMSearch", "JMSearchBar") {
            let scare = UIScreen.main.scale
            let imaName = String(format: "%@@%dx.png", name, Int(scare))
            if let imagePath = bundle.path(forResource: imaName, ofType: nil) {
                return UIImage(contentsOfFile: imagePath)
            }
            return nil
        }
        return nil
    }
}

extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if the button is hidden/disabled/transparent it can't be hit
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        
        // increase the hit frame to be at least as big as minimumHitArea
        let buttonSize = self.bounds.size
        let widthToAdd = max(minimumHitArea.width - buttonSize.width, 0)
        let heightToAdd = max(minimumHitArea.height - buttonSize.height, 0)
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        
        // perform hit test on larger frame
        return (largerFrame.contains(point)) ? self : nil
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

open class JMSearchTableView: UITableView {}

// MARK: UITableView数据源🈳️时占位图
extension JMSearchTableView {
    func setEmtpyViewDelegate(target: JMSearchViewProtocol) {
        self.emptyDelegate = target
        DispatchQueue.once(token: onceToken) {
            let cls = JMSearchTableView.self
            let originalSelector = #selector(self.reloadData)
            let swizzledSelector = #selector(self.jmSearch_reloadData)
            let originalMethod = class_getInstanceMethod(cls, originalSelector)
            let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
            let didAddMethod:Bool = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            if didAddMethod {
                class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else{
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
        }
    }
    
    @objc func jmSearch_reloadData() {
        self.jmSearch_reloadData()
        if isEmpty() {
            if let view = emptyDelegate?.configEmptyView() {
                if let subView = viewWithTag(JMSearchEmptyViewTag) {
                    subView.removeFromSuperview()
                }
                view.tag = JMSearchEmptyViewTag;
                addSubview(view)
            }
        }else {
            if let view = viewWithTag(JMSearchEmptyViewTag) {
                view.removeFromSuperview()
            }
        }
    }
    
    private func isEmpty() -> Bool {
        var secs = self.dataSource?.numberOfSections?(in: self)
        if secs == nil { secs = 1 }
        func getEmpty(_ section:Int) -> Bool {
            var isEmpty = true
            for i in 0...section {
                if let rows = self.dataSource?.tableView(self, numberOfRowsInSection: i) {
                    if rows > 0 {
                        isEmpty = false
                        break
                    }
                }
            }
            return isEmpty
        }
        return getEmpty(secs!)
    }
    
    //MARK:- ***** Associated Object *****
    private struct AssociatedKeys {
        static var emptyViewDelegate = "tableView_emptyViewDelegate"
    }
    
    private var emptyDelegate: JMSearchViewProtocol? {
        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.emptyViewDelegate) as? JMSearchViewProtocol)
        }
        set (newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.emptyViewDelegate, newValue!, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension DispatchQueue {
    private static var _onceToken = [String]()
    class func once(token: String = "\(#file):\(#function):\(#line)", block: ()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        if _onceToken.contains(token) { return }
        _onceToken.append(token)
        block()
    }
}
