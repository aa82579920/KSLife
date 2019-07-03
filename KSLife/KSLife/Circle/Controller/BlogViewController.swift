//
//  BlogViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/1.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class BlogViewController: UIViewController {
    
    private let itemH: CGFloat = 110
    private let msgTableViewCellID = "msgTableViewCellID"
    var blogs = [Blog]() {
        didSet {
            msgTableView.reloadData()
        }
    }
    
    lazy var msgTableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.rowHeight = itemH
        tableView.sectionFooterHeight = 10
        tableView.sectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(BlogTableViewCell.self, forCellReuseIdentifier: msgTableViewCellID)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(msgTableView)
    }
    
}

extension BlogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = msgTableView.dequeueReusableCell(withIdentifier: msgTableViewCellID, for: indexPath) as! BlogTableViewCell
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClick))
        
        cell.avatarImage.addGestureRecognizer(singleTapGesture)
        cell.avatarImage.tag = indexPath.section
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.blog = blogs[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailBlogViewController()
        vc.blog = blogs[indexPath.section]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func imageViewClick(ges: UIGestureRecognizer) {
        let vc = FriendViewController()
        if let view = ges.view as? UIImageView {
            vc.user = blogs[view.tag].userInfo
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
