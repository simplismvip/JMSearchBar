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

open class JMSearchController: UIViewController,JMSearchControllerProtocol {
    private let bag = DisposeBag()
    private var searchBar: JMSearchBarView!
    open var container: JMSearchView!
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
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
        container.delegate = self
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        setTableHeaderTltles()
        regietSearchBarEvent()
        setHeaderBackgroundType(type: .typeColorful)
    }
    
    open func setHeaderBackgroundType(type: JMCustomButtonType) {
        container.mainView.setBtnBackground(type: type)
    }
    
    open func searchViewDidScroll() {
        view.endEditing(true)
    }
    
    // MARK: -- 必须重写的代码 --
    open func reloadListResult(_ text:String) ->[JMSearchModel] {
        return [JMSearchModel]()
    }
    
    open func didSelectResult(_ model:JMSearchModel) {
        
    }
    
    open func setTableHeaderTltles() {
        let categories = ["text1","text2","text3","text4","text5","text6","text7","text8","text9","text10","text11","text12","text13","text14"]
        container.mainView.setTableHeader(categories)
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
                    let data = self?.reloadListResult(querytext)
                    DispatchQueue.main.async {
                        self?.container.listView.reloadDatasource(data!)
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
