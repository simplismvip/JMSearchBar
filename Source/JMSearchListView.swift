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

open class JMSearchListView: UIView,JMSearchViewProtocol {
    open var delegate:JMSearchSelectProtocol?
    private var dataSource = [JMSearchModel]()
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
    
    required public init?(coder aDecoder: NSCoder) { fatalError("implemented") }
}

extension JMSearchListView:UITableViewDelegate,UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
        if cell == nil { cell = SeatchCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cellid") }
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

extension JMSearchListView {
    public func configEmptyView() -> UIView? {
        let emptyView = JMSearchEmptyView(frame: self.bounds)
        emptyView.backgroundColor = UIColor.RGB(250, 250, 250)
        return emptyView
    }
    
    public func reloadDatasource(_ dataArr: [JMSearchModel]) {
        dataSource.append(contentsOf: dataSource)
        tableView.reloadData()
    }
    
    public func refashTableView(_ model: JMSearchModel) {
        dataSource.insert(model, at: 0)
        tableView.reloadData()
    }
}
