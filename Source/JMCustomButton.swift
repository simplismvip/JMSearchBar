//
//  JMCustomButton.swift
//  eBooks
//
//  Created by JunMing on 2019/11/25.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit

public enum JMCustomButtonType {
    case typeBackground
    case typeBorder
    case typeColorful
}

class JMCustomButton: UIButton {

    open var type: JMCustomButtonType? {
        didSet {
            guard let _type = type else { return }
            self.setType(type: _type)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initVIew()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open var isHighlighted: Bool {
        didSet {
            if let type = self.type {
                switch type {
                case .typeBorder:
                    switch isHighlighted {
                    case true:
                        layer.borderColor = UIColor.lightGray.cgColor
                    case false:
                        layer.borderColor = UIColor.darkGray.cgColor
                    }
                    
                case .typeColorful:
                    switch isHighlighted {
                    case true:
                        layer.borderColor = UIColor.lightGray.cgColor
                    case false:
                        layer.borderColor = UIColor.white.cgColor
                    }
                    
                case .typeBackground: break
                }
                
            } else {
                switch isHighlighted {
                case true:
                    layer.borderColor = UIColor.lightGray.cgColor
                case false:
                    layer.borderColor = UIColor.darkGray.cgColor
                }
            }
        }
    }
    open func initVIew() {
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 0.5
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.setTitleColor(UIColor.darkGray, for: .normal)
        self.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.layer.cornerRadius = 5
    }
    
    open func setType(type: JMCustomButtonType) {
        switch type {
        case .typeBackground:
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
            self.backgroundColor = UIColor.RGB(246, 246, 246)
            self.setTitleColor(UIColor.darkGray, for: .normal)
            self.setTitleColor(UIColor.darkGray.withAlphaComponent(0.3), for: .highlighted)
            
        case .typeBorder:
            self.layer.borderColor = UIColor.darkGray.cgColor
            self.layer.borderWidth = 1
            self.setTitleColor(UIColor.darkGray, for: .normal)
            self.setTitleColor(UIColor.darkGray.withAlphaComponent(0.3), for: .highlighted)
            
        case .typeColorful:
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
            self.backgroundColor = randomColor()
            self.setTitleColor(UIColor.white, for: .normal)
            self.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        }
    }
    
    open func randomColor() -> UIColor {
        let colorArray = ["009999", "0099cc", "0099ff", "00cc99", "00cccc", "336699", "3366cc", "3366ff", "339966", "666666", "666699", "6666cc", "6666ff", "996666", "996699", "999900", "999933", "99cc00", "99cc33", "660066", "669933", "990066", "cc9900", "cc6600" , "cc3300", "cc3366", "cc6666", "cc6699", "cc0066", "cc0033", "ffcc00", "ffcc33", "ff9900", "ff9933", "ff6600", "ff6633", "ff6666", "ff6699", "ff3366", "ff3333"]
        
        let randomNumber = arc4random_uniform(UInt32(colorArray.count))
        return UIColor(hexString: colorArray[Int(randomNumber)])
    }

}
