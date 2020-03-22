//
//  ViewController.swift
//  Example
//
//  Created by JunMing on 2020/3/22.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func startSearch(_ sender: Any) {
        let demo = DemoViewController()
        navigationController?.pushViewController(demo, animated: true)
    }
    
}


//override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.white
//        let search = JMSearchController()
////        registerEvent(eventName: kEBookFadebackEventName, block: { [weak self] _ in
////            let feedback = JMFeedbackController()
////            self?.navigationController?.pushViewController(feedback, animated: true)
////        }, next: false)
//    }
//    
////    override func pushViewController(_ bookName:String) {
////        let download = DownloadController()
////        download.bookName = bookName
////        navigationController?.pushViewController(download, animated: true)
////    }
