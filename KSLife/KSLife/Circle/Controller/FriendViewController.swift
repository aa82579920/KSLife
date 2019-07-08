//
//  FriendViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/30.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class FriendViewController: ViewController,  UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints {make in
            make.edges.equalToSuperview()
        }
        getFriendRemark(uid: user!.uid, success: { remark in
            self.remark = remark
            self.remarkLabel.text = remark
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    var remark: String = ""
    
    var user: BlogUserInfo? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var remarkLabel: UILabel = {
        let label = UILabel()
        label.text = user?.nickname ?? ""
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 50
        tableView.sectionFooterHeight = 20
        tableView.sectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
        }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            let image = UIImageView()
            image.sd_setImage(with: URL(string: user?.photo ?? ""), placeholderImage: UIImage(named: "noImg"))
            cell.contentView.addSubview(image)
            image.snp.makeConstraints { make in
                make.left.top.equalTo(cell.contentView).offset(10)
                make.bottom.equalTo(cell.contentView).offset(-10)
                make.width.equalTo(image.snp.height)
            }
            let label = UILabel()
            label.text = user?.nickname ?? ""
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 30)
            label.textColor = .black
            cell.contentView.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalTo(image.snp.right).offset(15)
                make.top.equalTo(cell.contentView).offset(15)
            }
            cell.contentView.addSubview(remarkLabel)
            remarkLabel.snp.makeConstraints { make in
                make.left.equalTo(label)
                make.bottom.equalTo(cell.contentView).offset(-15)
            }
        case 1:
            let label = UILabel()
            label.text = "设置备注"
            label.textAlignment = .left
            label.textColor = .black
            cell.contentView.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.bottom.equalTo(cell.contentView)
                make.left.equalTo(cell.contentView).offset(10)
            }
            let image = UIImageView()
            image.image = UIImage(named: "more_go")
            cell.contentView.addSubview(image)
            image.snp.makeConstraints { make in
                make.width.equalTo(15)
                make.height.equalTo(15)
                make.right.equalTo(cell.contentView).offset(-10)
                make.centerY.equalTo(cell.contentView)
            }
        case 2:
            let button = UIButton()
            button.backgroundColor = mainColor
            button.setTitle("发消息", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
            cell.contentView.addSubview(button)
            button.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section) {
        case 0:
            return 100
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let vc = RemarkViewController()
            vc.uid = user?.uid
            vc.remark = remark
            vc.hidesBottomBarWhenPushed = true
            vc.block = { remark in
                self.remarkLabel.text = remark
            }
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func setUpNav(_ animated: Bool){
        self.title = "详细资料"
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendMessage() {
        let vc = MessageViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.recUid = user!.uid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getFriendRemark(uid: String, success: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: UserAPIs.getFriendRemark, parameters: ["uid": uid], success: { dict in
            guard let data = dict["data"] as? [String: Any], let remark = data["remark"] as? String else {
                return
            }
            success(remark)
        }, failure: { _ in
            
        })
    }
}
