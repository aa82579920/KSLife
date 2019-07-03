//
//  oteViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

typealias RemarkBlock = (_ remark: String)->(Void)

class RemarkViewController: ViewController,  UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints {make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    var uid: String?
    var remark: String?
    var block: RemarkBlock?
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "请输入备注"
        field.clearButtonMode = .always
        field.text = remark ?? ""
        return field
    }()
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 110
        tableView.sectionFooterHeight = 20
        tableView.sectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
        }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
            cell.contentView.addSubview(textField)
            textField.snp.makeConstraints { make in
                make.top.bottom.right.equalToSuperview()
                make.left.equalToSuperview().offset(15)
            }
        case 1:
            let button = UIButton()
            button.backgroundColor = mainColor
            button.setTitle("完成", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(setRemark), for: .touchUpInside)
            cell.contentView.addSubview(button)
            button.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        default:
            break
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }
}

extension RemarkViewController {
    func setUpNav(_ animated: Bool){
        self.title = "设置备注"
        
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
    
    @objc func setRemark() {
        if textField.text == "" {
            self.tipWithLabel(msg: "备注不能为空")
        } else {
            setFriendRemark(uid: uid!, remark: textField.text!, success: { remark in
                self.block!(remark)
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func setFriendRemark(uid: String, remark: String, success: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .get, url: UserAPIs.setFriendRemark, parameters: ["uid": uid, "remark": remark], success: { _ in
            success(remark)
        }, failure: { _ in
            
        })
    }
}
