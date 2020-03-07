//
//  JMSearchMainView.swift
//  eBooks
//
//  Created by JunMing on 2019/11/23.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

open class JMSearchMainView: UIView  {
    open var delegate:JMSearchSelectProtocol?
    var ynSearch = JMSearchStore()
    var dataSource = [JMSearchModel]()
    private lazy var playholderView:JMSearchEmptyView = {
        let emptyView = JMSearchEmptyView(frame: CGRect(x: 0, y: 200, width: width, height: height-230))
        emptyView.backgroundColor = UIColor.white
        return emptyView
    }()
    
    open lazy var tableView:JMSearchTableView = {
        let tabView = JMSearchTableView(frame: self.bounds, style: .grouped)
        tabView.register(SeatchCell.self, forCellReuseIdentifier: "cellid")
        tabView.delegate = self
        tabView.dataSource = self
        tabView.setEmtpyViewDelegate(target: self)
        tabView.backgroundColor = UIColor.white
        tabView.sectionHeaderHeight = 0;
        tabView.sectionFooterHeight = 0;
        tabView.tableHeaderView = headerView
        return tabView
    }()
    
    fileprivate lazy var headerView:TableHeaderView = {
        let headerV = TableHeaderView(frame: CGRect(x: 0, y: 0, width: self.width, height: 230))
        headerV.updateSizeHeight = { sizeHeight in
            var newBounds = headerV.bounds
            newBounds.size.height = sizeHeight
            headerV.bounds = newBounds
            self.tableView.tableHeaderView = headerV
        }
        headerV.tabHeaderClick = { [weak self] text in
            let model = JMSearchModel(title: text)
            self?.delegate?.didSelectCallback(model: model)
            self?.refashTableView(model)
        }
        return headerV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setBtnBackground(type: JMCustomButtonType) {
        headerView.setButtonType(type: type)
    }
}

extension JMSearchMainView:JMSearchViewProtocol {
    
    public func reloadDatasource<T>(_ dataArr: [T]) {
        if dataArr is [JMSearchModel] {
            dataSource = dataArr as! [JMSearchModel]
            tableView.reloadData()
        }
    }
    
    public func refashTableView<T>(_ model: T) {
        
        if let value = model as? JMSearchModel {
            var isExist = false
            for newValue in dataSource {
                if newValue.title == value.title {
                    isExist = true
                    break
                }
            }
            if !isExist {
                dataSource.insert(value, at: 0)
                tableView.reloadData()
            }
        }
    }
    
    public func configEmptyView() -> UIView? {
        return playholderView
    }
}

extension JMSearchMainView:UITableViewDelegate,UITableViewDataSource {
    
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
        newCell.closeCurrentBlock = { text in
            self.dataSource.remove(at: indexPath.row)
            tableView.reloadData()
            JMSearchStore.shared.deleteModel(by: text)
        }
        return newCell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.didSelectCallback(model: dataSource[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var headerViw = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if headerViw == nil {
            headerViw = HeaderView(frame: CGRect(x: 0, y: 0, width: self.width, height: 35))
        }
        
        let newHeader = headerViw as! HeaderView
        newHeader.clearAllBlock = { [weak self] in
            self?.dataSource.removeAll()
            tableView.reloadData()
            if let cacheDirectory = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last {
                let path = cacheDirectory+"/history"
                JMSearchStore.shared.deleteDecode(path)
            }
        }
        return newHeader;
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}

class SeatchCell: UITableViewCell {
    
    var title:UILabel!
    open var closeCurrentBlock:((String)->())?
    open var close:UIButton!
    private var bag:DisposeBag = DisposeBag()
    private var imaView:UIImageView!
    private var spliteLine:UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        imaView = UIImageView(image: UIImage(named: "icons8-more"))
        imaView.image = UIImage.imageNamed(bundleName: "search_history")
        imaView.contentMode = UIView.ContentMode.scaleAspectFill
        imaView.clipsToBounds = true;
        contentView.addSubview(imaView)
        
        title = UILabel()
        title.text = "测试文本"
        title.numberOfLines = 0
        title.textColor = UIColor.gray
        title.font = UIFont.medium(15)
        contentView.addSubview(title)
        
        close = UIButton(type: UIButton.ButtonType.system)
        close.tintColor = UIColor.gray
        
        close.setImage(UIImage.imageNamed(bundleName: "close"), for: UIControl.State.normal)
        contentView.addSubview(close)
        close.rx.tap.subscribe(onNext: { [weak self] in
            print("save Tapped")
            self?.closeCurrentBlock?((self?.title.text)!)
        }).disposed(by: bag)
        
        spliteLine = UIView()
        spliteLine.backgroundColor = UIColor.RGBA(220, 220, 220, 0.5)
        contentView.addSubview(spliteLine)
        
        layoutViews(true)
    }
    
    func layoutViews(_ iconShow:Bool) {
        imaView.snp.makeConstraints { (make) in
            make.width.height.equalTo(15)
            make.left.equalTo(contentView).offset(8)
            make.centerY.equalTo(contentView.snp_centerY)
        }
        
        close.snp.makeConstraints { (make) in
            make.height.width.equalTo(34)
            make.right.equalTo(self.snp_right).offset(-8)
            make.centerY.equalTo(imaView.snp_centerY)
        }
        
        spliteLine.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.right.equalTo(self).offset(-8)
            make.height.equalTo(1)
            make.bottom.equalTo(self.snp_bottom)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(imaView.snp_right).offset(8)
            make.right.equalTo(close.snp_left).offset(-8)
            make.bottom.equalTo(spliteLine.snp_top)
            make.top.equalTo(self.snp_top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TableHeaderView: UIView {
    private var margin: CGFloat = 8
    open var fitSizeHeight:CGFloat = 0 {
        willSet { updateSizeHeight?(newValue) }
    }
    public var updateSizeHeight:((CGFloat)->())?
    public var tabHeaderClick:((String)->())?
    
    //private var tabHeaderLabel = ScrollTabView()
    private var tabHeaderLabel = UILabel()
    private var customButtons = [JMCustomButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let categories = SQLHelper.share.fetchNamesData()
//        initView(categories: categories)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func initView(categories: [String]) {
        tabHeaderLabel.text = "推荐下载"
        tabHeaderLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(tabHeaderLabel)
        for i in 0..<categories.count {
            let button = JMCustomButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            button.setTitle(categories[i], for: .normal)
            customButtons.append(button)
            addSubview(button)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tabHeaderLabel.frame = CGRect(x: margin, y: 3, width: width - margin*2, height: 28)
        let font = UIFont.systemFont(ofSize: 12)
        let userAttributes = [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor: UIColor.gray]
        
        var minY = tabHeaderLabel.height + margin
        var minX = margin
        for (index,item) in customButtons.enumerated() {
            if let title = item.titleLabel?.text {
                let size = title.size(withAttributes: userAttributes)
                if index > 0 {
                    let lastItem = customButtons[index - 1]
                    let maxX = lastItem.width + lastItem.x + margin
                    if maxX + size.width + margin > self.width - margin {
                        minY += 25 + margin
                        minX = margin
                    }else{
                        minX = maxX
                    }
                }
                item.frame = CGRect(x: minX, y: minY, width: size.width + margin, height: 25)
            }
        }
        fitSizeHeight = minY+25+margin
    }
    
    @objc open func buttonClicked(_ sender: UIButton) {
        if let text = sender.titleLabel?.text {
            tabHeaderClick?(text)
        }
    }
    
    open func setButtonType(type: JMCustomButtonType) {
        for cusButton in customButtons {
            cusButton.type = type
        }
    }
}

class HeaderView: UITableViewHeaderFooterView {
    open var clearAllBlock:(()->())?
    private var bag:DisposeBag = DisposeBag()
    private var searchHistoryLabel:UILabel!
    private var clearHistory:UIButton!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        searchHistoryLabel = UILabel()
        searchHistoryLabel.text = "搜索历史"
        searchHistoryLabel.font = UIFont.systemFont(ofSize: 14)
        searchHistoryLabel.textColor = UIColor.black
        addSubview(searchHistoryLabel)
        
        clearHistory = UIButton(type: UIButton.ButtonType.system)
        clearHistory.tintColor = UIColor.gray
        clearHistory.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        clearHistory.setTitle("清空", for: UIControl.State.normal)
        addSubview(clearHistory)
        clearHistory.rx.tap.subscribe(onNext: { [weak self] in
            self?.clearAllBlock?()
            print("save Tapped")
        }).disposed(by: bag)
        
        searchHistoryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.height.equalTo(self)
        }
        
        clearHistory.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.right.equalTo(self.snp_right).offset(-8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 头部 View 类型滑动
class ScrollTabView: UIView {
    let scrollView = UIScrollView()
    var items = ["文学","名著","小说","传记","经济","热门"]
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        for (index,item) in items.enumerated() {
            let btn = UIButton(type: UIButton.ButtonType.system)
            btn.layer.cornerRadius = 14
            btn.tag = index + 100
            btn.tintColor = UIColor.gray
            btn.titleLabel?.font = UIFont.medium(15)
            btn.addTarget(self, action: #selector(touchAction(_:)), for: UIControl.Event.touchUpInside)
            btn.setTitle(item, for: UIControl.State.normal)
            scrollView.addSubview(btn)
        }
        changeBackgroundColor(scrollView.subviews.first as! UIButton)
    }
    
    @objc func touchAction(_ sender:UIButton) {
        print(items[sender.tag-100])
        changeBackgroundColor(sender)
    }
    
    func changeBackgroundColor(_ sender:UIButton) {
        for view in scrollView.subviews {
            let btn = view as! UIButton
            if btn.tag == sender.tag {
                btn.tintColor = UIColor.white
                btn.backgroundColor = UIColor.RGBA(181, 181, 181, 0.8)
            }else{
                btn.tintColor = UIColor.gray
                btn.backgroundColor = UIColor.white
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = bounds
        let btnWith:CGFloat = 54
        let margin:CGFloat = 5
        let wid = CGFloat(items.count) * (btnWith+margin)
        scrollView.contentSize = CGSize(width: wid, height: height)
        
        var stepX:CGFloat = 0
        for (index,view) in scrollView.subviews.enumerated() {
            view.frame = CGRect(x: margin + stepX, y: 0, width: btnWith, height: height)
            stepX = (btnWith+margin) * CGFloat(index+1)
        }
    }
    
}
