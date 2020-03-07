//
//  JMSearchInterface.swift
//  eBooks
//
//  Created by JunMing on 2019/11/28.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit
import RxSwift

public protocol JMSearchViewProtocol {
    // MARK: - 刷新全部Models
    func reloadDatasource<T>(_ dataArr:[T])
    // MARK: - 刷新单个Model
    func refashTableView<T>(_ model:T)
    // MARK: - 配置空数据提示图用于展示
    func configEmptyView() -> UIView?
}

extension JMSearchViewProtocol {
    func configEmptyView() -> UIView? {
        return nil
    }
}

public protocol JMSearchSelectProtocol {
    func didSelectCallback<T>(model:T)
}

extension JMSearchSelectProtocol {
    
}
