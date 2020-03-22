//
//  JMSearchEmptyView.swift
//  eBooks
//
//  Created by JunMing on 2019/12/2.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit

class JMSearchEmptyView: UIView {

    private var fackback = UIButton(type: .system)
    private var imageV = UIImageView(image: UIImage.imageNamed(bundleName: "tv_default_pic_nofollowing"))
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageV.contentMode = UIView.ContentMode.scaleAspectFill
        imageV.clipsToBounds = true;
        addSubview(imageV)
        
        fackback.setTitle("没找到想要的，点我反馈", for: .normal)
        fackback.tintColor = UIColor.gray
        fackback.addTarget(self, action: #selector(fackbackAction), for: .touchUpInside)
        addSubview(fackback)
        
        imageV.snp.makeConstraints { (make) in
            make.width.height.equalTo(170)
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY).offset(-50)
        }
        
        fackback.snp.makeConstraints { (make) in
            make.top.equalTo(imageV.snp.bottom).offset(10)
            make.width.equalTo(self)
            make.height.equalTo(34)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    @objc func fackbackAction() {
        print("fack back action")
        //routerEvent(eventName: kEBookFadebackEventName, info: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
