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
//    // MARK: - 刷新全部Models
//    func reloadDatasource<T>(_ dataArr:[T])
//    // MARK: - 刷新单个Model
//    func refashTableView<T>(_ model:T)
//    // MARK: - 刷新推荐View
//    func setTableHeader(_ titles:[String])
    // MARK: - 配置空数据提示图用于展示
    func configEmptyView() -> UIView?
}

extension JMSearchViewProtocol {
    public func configEmptyView() -> UIView? {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        let emptyView = JMSearchEmptyView(frame: CGRect(x: 0, y: 200, width: width, height: height-230))
        emptyView.backgroundColor = UIColor.white
        return emptyView
    }
}

public protocol JMSearchSelectProtocol {
    func didSelectCallback<T>(model:T)
}

extension JMSearchSelectProtocol {
    
}

public protocol JMSearchDataProtocol {
    // MARK: - 刷新全部Models
    func reloadMainTableView<T>(_ dataArr:[T])
    // MARK: - 刷新单个Model
    func reloadMainHeaderView<T>(_ model:T)
    
    // MARK: - 刷新全部Models
    func reloadListResult<T>(_ dataArr:[T])
    
    // MARK: - 配置空数据提示图用于展示
    func configEmptyView() -> UIView?
}

public protocol JMSearchControllerProtocol {
    func reloadListResult(_ text:String) ->[JMSearchModel]
    func didSelectResult(_ model:JMSearchModel)
    func searchViewDidScroll()
}

