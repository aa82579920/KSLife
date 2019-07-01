//
//  SignInViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/4.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
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
    
    private let placeText = ["手机号：", "验证码：", "密码："]
    private var fields: [UITextField] = []
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 60
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        return tableView
        }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 4 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let label = UILabel()
                label.text = "康食"
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
                label.textColor = .white
                label.backgroundColor = mainColor
                cell.contentView.addSubview(label)
                label.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else {
                let field = UITextField()
                field.placeholder = placeText[indexPath.row - 1]
                field.backgroundColor = .white
                cell.contentView.addSubview(field)
                field.snp.makeConstraints {make in
                    make.left.equalTo(cell.contentView).offset(5)
                    make.right.top.bottom.equalTo(cell.contentView)
                }
                fields.append(field)
                if indexPath.row == 2 {
                    let button = UIButton()
                    button.backgroundColor = mainColor
                    button.setTitle("获取验证码", for: .normal)
                    button.setTitleColor(.white, for: .normal)
                    button.addTarget(self, action: #selector(getCode), for: .touchUpInside)
                    
                    cell.contentView.addSubview(button)
                    button.snp.makeConstraints {make in
                        make.right.bottom.equalTo(cell.contentView).offset(-5)
                        make.top.equalTo(cell.contentView).offset(5)
                        make.width.equalTo(cell.contentView).multipliedBy(0.3)
                    }
                }
            }
        default:
            let button = UIButton()
            button.backgroundColor = mainColor
            button.setTitle("下一步", for: .normal)
            cell.contentView.addSubview(button)
            button.addTarget(self, action: #selector(getter: next), for: .touchUpInside)
            button.snp.makeConstraints {make in
                make.left.right.centerY.equalToSuperview()
            }
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            return screenH / 4
        case (1, 0):
            return 200
        default:
            return 60
        }
    }
    
    
    func setUpNav(_ animated: Bool){
        self.title = ""
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: mainColor), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func getCode() {
        guard let mobile = fields[0].text, let code = fields[1].text, let pass = fields[2].text else {
            return
        }
        var msg: String?
        if mobile.count == 0 {
            msg = "手机号不能为空"
        } else if !NSRegularExpression("^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$").matches(pass) {
            msg = "手机号输入错误"
        } else {
            SolaSessionManager.solaSession(type: .post, url: UserAPIs.checkDuplicate, parameters: ["mobile": mobile], success: { dict in
                guard let data = dict["data"] as? [String: Any], let duplicate = data["duplicate"] as? Int else {
                    return
                }
                if duplicate == 0 {
                    SolaSessionManager.solaSession(type: .post, url: UserAPIs.getMobileVerifyCode, parameters: ["mobile": mobile], success: { _ in
                        msg = "已发送"
                    }, failure: { _ in
                        
                    })
                } else {
                    msg = "手机号已注册"
                }
            }, failure: { _ in
                
            })
        }
        tipWithLabel(msg: msg ?? "")
    }
    
    @objc func next() {
        
    }
}
