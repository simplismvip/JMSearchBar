//
//  JMSearchController.swift
//  eBooks
//
//  Created by JunMing on 2019/11/25.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class JMSearchController: UIViewController {
    fileprivate lazy var bag = DisposeBag()
    fileprivate var searchBar: JMSearchBarView!
    open var container: JMSearchView!
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
        regietSearchBarEvent()
        regietSearchContentEvent()
        setHeaderBackgroundType(type: .typeColorful)
    }
    
    open func pushViewController(_ bookName:String) {
        
    }
    
    open func setupSubViews() {
        searchBar = JMSearchBarView(frame: CGRect(x:0, y:0, width:self.view.width, height:44))
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }else{
                make.top.equalTo(self.topLayoutGuide.snp.top)
            }
            make.width.equalTo(self.view)
            make.height.equalTo(44)
        }
        
        container = JMSearchView(frame: CGRect(x:0, y:0, width:0, height:0))
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp_bottom)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    
    open func setHeaderBackgroundType(type: JMCustomButtonType) {
        container.mainView.setBtnBackground(type: type)
    }
}

extension JMSearchController {
    func regietSearchBarEvent() {
        
        // 文本存在的时候隐藏，不存在显示
        // $0.count > 0
        searchBar.textField.rx.text.orEmpty.map { $0.count == 0 }.share(replay: 1).distinctUntilChanged().subscribe(onNext: { [weak self] (mainHide:Bool) in
            self?.switchMainAndListView(mainHide: mainHide)
        }).disposed(by: bag)
        
        // 当文本框内容改变时，将内容输出到控制台上
        searchBar.textField.rx.text.orEmpty.filter { $0.count > 0 }.distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                // self.searchRun($0)
                print("内容输出:\($0)")
                let querytext = $0
                DispatchQueue.global().async {
                    let result = SQLHelper.share.fetchSearchResultData(querytext)
                    DispatchQueue.main.async {
                        self?.container.listView.reloadDatasource(result)
                    }
                }
            }).disposed(by: bag)
        
        // 状态可以组合
        searchBar.textField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { _ in
                print("开始编辑内容!")
            }).disposed(by: bag)
        
        // 在用户名输入框中按下 return 键
        searchBar.textField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
            [weak searchBar] in
            searchBar?.textField.becomeFirstResponder()
            print("search:\($0)")
        }).disposed(by: bag)
        
        // 取消按钮
        searchBar.cancel.rx.tap.subscribe(onNext: { [weak self] in
            print("Cancle action")
            if let nav = self?.navigationController {
                nav.popViewController(animated: true)
            }else {
                self?.dismiss(animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }
    
    func regietSearchContentEvent() {
        // 收回键盘
        container.searchViewDidScroll = { [weak self] in
            self?.view.endEditing(true)
        }
        
        // 点击搜索结构
        container.clickResult = { [weak self] model in
            print("store success, next step push")
            if let newModel = model as? JMSearchModel {
                self?.pushViewController(newModel.title!)
            }
        }
    }
    
    func searchRun(_ key:String) {
        var result = [String]()
        for i in 0 ... key.count {
            result.append("text:\(i)")
        }
        container.listView.reloadDatasource(result)
    }
    
    func switchMainAndListView(mainHide:Bool) {
        print("mainHide:\(mainHide)")
        self.searchBar.textField.hideClose(mainHide)
        UIView.animate(withDuration: 0.3, animations: {
            self.container.mainView.alpha = mainHide ? 1:0
            self.container.listView.alpha = mainHide ? 0:1
        }) { (true) in
            self.container.mainView.isHidden = !mainHide
            self.container.listView.isHidden = mainHide
        }
    }
}
