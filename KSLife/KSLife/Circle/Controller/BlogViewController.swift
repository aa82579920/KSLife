//
//  BlogViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/1.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import MJRefresh

class BlogViewController: UIViewController {
    
    private let itemH: CGFloat = 110
    private let msgTableViewCellID = "msgTableViewCellID"
    var type: Int?
    var blogs = [Blog]() {
        didSet {
            msgTableView.reloadData()
        }
    }
    private var page: Int = 0
    
    lazy var msgTableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
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
        getBlogs(uid: UserInfo.shared.user.uid, type: type!, page: 0, success: { list in
            self.blogs = list
        })
        msgTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: Selector(("refresh")))
        header.lastUpdatedTimeLabel.isHidden = true
        msgTableView.mj_header = header
        let footer = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: Selector(("getMore")))
        footer.setTitle("没有更多数据了", for: .noMoreData)
        msgTableView.mj_footer = footer
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
    
    @objc func refresh() {
        page = 0
        getBlogs(uid: UserInfo.shared.user.uid, type: type!, page: 0, success: { list in
            self.blogs = list
        })
        self.msgTableView.mj_header.endRefreshing()
    }
    
    @objc func getMore() {
        page += 1
        getBlogs(uid: UserInfo.shared.user.uid, type: type!, page: page, success: { list in
            if list.count <= 0 {
                self.msgTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.blogs += list
            }
        })
        self.msgTableView.mj_footer.endRefreshing()
    }
}

extension BlogViewController {
    func getBlogs(uid: String,  type: Int, page: Int, success: @escaping ([Blog]) -> Void) {
        //        let disGroup = DispatchGroup()
        SolaSessionManager.solaSession(type: .post, url: BlogAPIs.getBlogs, parameters: ["uid": uid, "page": "\(page)", "type": "\(type)"], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: [])
                let tBlog = try JSONDecoder().decode([Blog].self, from: json)
                success(tBlog)
            } catch {
                print("cant show blog")
            }
        }, failure: { error in
            print(error)
        })
    }
    
    func getBlog(bid: Int, success: @escaping (Blog) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: BlogAPIs.getBlog, parameters: ["bid": "\(bid)"], success: { dict in
            guard let data = dict["data"] as? [String: Any], let blog = data["blog"] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: blog, options: [])
                let tBlog = try JSONDecoder().decode(Blog.self, from: json)
                success(tBlog)
            } catch {
                print("cant show blog")
            }
        }, failure: { _ in
            
        })
    }
}
