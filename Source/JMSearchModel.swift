//
//  JMSearchModel.swift
//  eBooks
//
//  Created by JunMing on 2019/11/26.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit

class JMSearchModel: Codable {
    var leftIcon:String = "search_history"
    var rightIcon:String = "close"
    var download:Bool = false
    var title:String?
    
    // 需要传递的Model，但是需要遵循Codable协议
//    var temp:Model?
    
    init(title name:String){
        self.title = name
    }
    
    init() {}
}
