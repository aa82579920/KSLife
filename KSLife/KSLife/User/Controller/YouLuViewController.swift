//
//  YouLuViewController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/17.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
struct Device {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}
// 友录页面
class YouLuViewController: UIViewController {
    
    //Section标题 及 索引标题
    fileprivate var sectionArray: [String] {
        var sectionArray = [String]()
        for index in 0..<26 {
            sectionArray.append(String(UnicodeScalar(index + 65)!))
        }
        return sectionArray
    }
    fileprivate var tableView = UITableView()
    fileprivate var sectionCount = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "通讯录"
        self.view.backgroundColor = .white
        
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
}
extension YouLuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return YouLuTableViewCell(index: indexPath.row)
    }
    // 设置每个Section标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

