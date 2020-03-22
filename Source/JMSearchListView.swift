//
//  JMSearchListView.swift
//  eBooks
//
//  Created by JunMing on 2019/11/25.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

open class JMSearchListView: UIView {
    open var delegate:JMSearchSelectProtocol?
    fileprivate var dataSource = [JMSearchModel]()
    private lazy var playholderView:JMSearchEmptyView = {
        let emptyView = JMSearchEmptyView(frame: self.bounds)
        emptyView.backgroundColor = UIColor.RGB(250, 250, 250)
        return emptyView
    }()
    
    open lazy var tableView:JMSearchTableView = {
        let tabView = JMSearchTableView(frame: self.bounds, style: .plain)
        tabView.register(SeatchCell.self, forCellReuseIdentifier: "cellid")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.setEmtpyViewDelegate(target: self)
        tabView.backgroundColor = UIColor.white
        return tabView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension JMSearchListView:UITableViewDelegate,UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil {
            cell = SeatchCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellid")
        }
        let newCell = cell as! SeatchCell
        let model = dataSource[indexPath.row]
        newCell.title.text = model.title
        newCell.close.setImage(UIImage.imageNamed(bundleName: model.rightIcon), for: UIControl.State.normal)
        newCell.closeCurrentBlock = { text in
            self.dataSource.remove(at: indexPath.row)
            tableView.reloadData()
        }
        return newCell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        delegate?.didSelectCallback(model: model)
    }
}


extension JMSearchListView:JMSearchViewProtocol {
    
    public func configEmptyView() -> UIView? {
        return playholderView
    }
    
    public func reloadDatasource<T>(_ dataArr: [T]) {
        if dataArr is [JMSearchModel] {
            dataSource = dataArr as! [JMSearchModel]
            tableView.reloadData()
        }
    }
    
    public func refashTableView<T>(_ model: T) {
        dataSource.insert(model as! JMSearchModel, at: 0)
        tableView.reloadData()
    }
}
