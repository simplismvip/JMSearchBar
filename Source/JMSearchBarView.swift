//
//  JMSearchBarView.swift
//  eBooks
//
//  Created by JunMing on 2019/11/25.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit
class JMTextFieldView: UITextField {
    private var leftMargin:CGFloat = 10
    open var pholderColor = UIColor.red {
        willSet { self.setValue(newValue, forKey: "_placeholderLabel.textColor") }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.RGB(241, 241, 241);
        self.layer.cornerRadius = 10
        self.layer.borderColor = self.backgroundColor?.cgColor
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: 14)
        self.placeholder = "搜索喜欢的内容"
        //self.tintColor = UIColor.colorFromHexString("#1E90FF")
        self.returnKeyType = .search
        self.layer.borderWidth = 1
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        
        let leftImage = UIImage.imageNamed(bundleName: "searchicon")!
        let leftImageView = UIImageView(frame: CGRect(x: 20, y: 0, width: leftImage.size.width, height: leftImage.size.height))
        leftImageView.image = leftImage
        leftImageView.tintColor = UIColor.white
        leftImageView.contentMode = UIView.ContentMode.center;
        self.leftViewMode = .always
        self.leftView = leftImageView
        
        let rightImage = UIImage.imageNamed(bundleName: "deleteinput")
        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        rightButton.frame = CGRect(x: frame.size.width - 20, y: 0, width: leftImage.size.width, height: leftImage.size.height)
        rightButton.setImage(rightImage, for: UIControl.State.normal)
        rightButton.setImage(rightImage, for: UIControl.State.highlighted)
        rightButton.tintColor = UIColor.white
        rightButton.contentMode = UIView.ContentMode.center;
        rightButton.addTarget(self, action: #selector(clearTextFiled), for: UIControl.Event.touchUpInside)
        self.rightView = rightButton;
        self.rightViewMode = .always;
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        iconRect.origin.x += self.leftMargin
        return iconRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var editingRect = super.editingRect(forBounds: bounds)
        editingRect.origin.x += 10;
        editingRect.size.width -= 2 * self.leftMargin;
        return editingRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x += 10
        return textRect;
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.rightViewRect(forBounds: bounds)
        iconRect.origin.x -= self.leftMargin
        return iconRect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let placeholdRect = super.placeholderRect(forBounds: bounds)
        return placeholdRect
    }
    
    @objc func clearTextFiled() {
        self.text = ""
        self.hideClose(true)
        self.sendActions(for: .allEditingEvents)
    }
    
    open func hideClose(_ hide:Bool) {
        self.rightView?.isHidden = hide
    }
}

class JMSearchBarView: UIView {
    open var textField: JMTextFieldView!
    open var cancel: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cancel = UIButton(type: UIButton.ButtonType.system)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        //cancel.setTitleColor(UIColor.colorFromHexString("#1E90FF"), for: .normal)
        cancel.setTitle("取消", for: .normal)
        addSubview(cancel)
        cancel.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp_right).offset(-7)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(34)
        }
        
        textField = JMTextFieldView(frame: CGRect(x: 0, y: 0, width: self.width - 50, height: self.height))
        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp_left).offset(10)
            make.right.equalTo(cancel.snp_left).offset(-5)
            make.top.equalTo(5)
            make.bottom.equalTo(-5)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
