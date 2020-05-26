//
//  JMSearchView.swift
//  eBooks
//
//  Created by JunMing on 2019/11/25.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

open class JMSearchView: UIView, JMSearchSelectProtocol {
    private let bag = DisposeBag()
    open var mainView: JMSearchMainView!
    open var listView: JMSearchListView!
    open var delegate:JMSearchControllerProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainView = JMSearchMainView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        mainView.delegate = self
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        listView = JMSearchListView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        listView.delegate = self
        addSubview(listView)
        listView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        // 调用方法
        regietSearchContentEvent()
        startMainContent()
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    open func didSelectCallback<T>(model:T) {
        delegate?.didSelectResult(model as! JMSearchModel)
        JMSearchStore.shared.encodeModel(model as! JMSearchModel)
    }
}

extension JMSearchView {
    func regietSearchContentEvent() {
        // 监听滚动
        Observable.combineLatest(
            mainView.tableView.rx.contentOffset,
                                 listView.tableView.rx.contentOffset)
            .subscribe(onNext: { [weak self] (_) in
                self?.delegate?.searchViewDidScroll()
        } ).disposed(by: bag)
    }
    
    //MARK: read search history
    func startMainContent() {
        JMSearchStore.shared.decodeModels { [weak self] (models:[JMSearchModel]?) in
            if let result = models {
                self?.mainView.reloadDatasource(result)
            }
        }
    }
    
}
