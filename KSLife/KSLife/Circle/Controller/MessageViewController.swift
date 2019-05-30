//
//  MessageViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/1.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    private let itemH: CGFloat = 110
    private let msgTableViewCellID = "msgTableViewCellID"
    
    private lazy var msgTableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.estimatedRowHeight = itemH
        tableView.sectionFooterHeight = 10
        tableView.sectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MsgTableViewCell.self, forCellReuseIdentifier: msgTableViewCellID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(msgTableView)
    }
    
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = msgTableView.dequeueReusableCell(withIdentifier: msgTableViewCellID, for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MsgDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
