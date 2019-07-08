//
//  ResetPassViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/4.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class ResetPassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    
    private var timer: Timer?
    
    private var isCounting: Bool = false {
        willSet(newValue) {
            if newValue {
                timer = Timer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                RunLoop.main.add(timer!, forMode: .common)
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    private var remainingSeconds: Int = 0 {
        willSet(newSeconds) {
            let seconds = newSeconds%60
            codeBtn.setTitle(String(format:
                "(%02d)重新发送", seconds), for: .normal)
        }
    }
    
    private var fields: [UITextField] = []
    private let titles = ["手机号：", "验证码：", "新密码：", "确认密码："]
    private let placeText = ["请输入注册的手机号", "请输入验证码", "密码", "确认密码"]
    
    private lazy var codeBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = mainColor
        button.setTitle("获取验证码", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 60
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
        
        if indexPath.section == 0 {
            let label = UILabel()
            label.text = titles[indexPath.row]
            label.textColor = .black
            label.textAlignment = .left
            cell.contentView.addSubview(label)
            let field = UITextField()
            field.placeholder = placeText[indexPath.row]
            field.backgroundColor = .white
            if indexPath.row != 3 {
                field.returnKeyType = .next
            }
            fields.append(field)
            cell.contentView.addSubview(field)
            label.snp.makeConstraints {make in
                make.top.bottom.equalTo(cell.contentView)
                make.left.equalTo(cell.contentView).offset(10)
                make.width.equalTo(cell.contentView).multipliedBy(0.22)
            }
            field.snp.makeConstraints {make in
                make.right.top.bottom.equalTo(cell.contentView)
                make.left.equalTo(label.snp.right)
            }
            if indexPath.row == 1 {
                cell.contentView.addSubview(codeBtn)
                codeBtn.snp.makeConstraints {make in
                    make.right.bottom.equalTo(cell.contentView).offset(-5)
                    make.top.equalTo(cell.contentView).offset(5)
                    make.width.equalTo(cell.contentView).multipliedBy(0.3)
                }
            }
        } else {
            let button = UIButton()
            button.backgroundColor = mainColor
            button.setTitle("确认修改", for: .normal)
            button.addTarget(self, action: #selector(ensure), for: .touchUpInside)
            cell.contentView.addSubview(button)
            button.snp.makeConstraints {make in
                make.edges.equalToSuperview()
            }
        }
        return cell
    }
    
    func setUpNav(_ animated: Bool){
        self.title = "修改密码"
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func updateTimer(timer: Timer) {
        if remainingSeconds > 0 {
            remainingSeconds -= 1
        }
        
        if remainingSeconds == 0 {
            codeBtn.setTitle("获取验证码", for: .normal)
            codeBtn.isEnabled = true
            isCounting = !isCounting
            timer.invalidate()
        }
    }
    
    @objc func getCode() {
        
        for textField in fields {
            textField.resignFirstResponder()
        }
        
        guard let mobile = fields[0].text else {
            tipWithLabel(msg: "手机号不能为空")
            return
        }
        let regex = NSRegularExpression("^((13[0-9])|(15[^4,\\D]) |(17[0,0-9])|(18[0,0-9]))\\d{8}$")
        if mobile.count == 0 {
            tipWithLabel(msg: "手机号不能为空")
        } else if !regex.matches(mobile) {
            tipWithLabel(msg: "手机号输入错误")
        } else {
            remainingSeconds = 59
            isCounting = !isCounting
            SolaSessionManager.solaSession(type: .post, url: UserAPIs.getMobileVerifyCode, parameters: ["mobile": mobile], success: { dict in
                guard let status = dict["status"] as? Int else {
                    return
                }
                if status == 200 {
                    self.tipWithLabel(msg: "已发送")
                } else {
                    if let msg = dict["msg"] as? String {
                        self.tipWithLabel(msg: "康食：" + msg)
                    }
                }
            }, failure: { error in
                self.tipWithLabel(msg: "康食：" + error.localizedDescription)
            })
        }
    }
    
    @objc func ensure() {
        
        for textField in fields {
            textField.resignFirstResponder()
        }
        
        guard let mobile = fields[0].text, let code = fields[1].text, let newpass = fields[2].text, let repeatpass = fields[3].text else {
            return
        }
        var msg: String?
        if mobile.count == 0 {
            msg = "手机号不能为空"
        } else if code.count == 0 {
            msg = "验证码不能为空"
        } else if newpass.count == 0 || repeatpass.count == 0 {
            msg = "密码不能为空"
        } else if newpass != repeatpass{
            msg = "两次密码输入不一致"
        } else if !NSRegularExpression("^[a-zA-Z0-9]{6,20}+$").matches(newpass) {
            msg = "很抱歉，密码只能是6-20位的数字字母，或数字和字母的组合"
        } else {
            SolaSessionManager.solaSession(type: .post, url: UserAPIs.resetPassword, parameters: ["mobile": mobile, "code": code, "newpass": newpass.MD5], success: { dict in
                guard let status = dict["status"] as? Int else {
                    return
                }
                if status == 200 {
                     msg = "修改成功"
                } else {
                    if let msg = dict["msg"] as? String {
                        self.tipWithLabel(msg: "康食：" + msg)
                    }
                }
            }, failure: { error in
                msg = error.localizedDescription
            })
        }
        tipWithLabel(msg: msg!)
    }
}

extension ResetPassViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for textField in fields {
            textField.resignFirstResponder()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for textField in fields {
            textField.resignFirstResponder()
        }
    }
}
