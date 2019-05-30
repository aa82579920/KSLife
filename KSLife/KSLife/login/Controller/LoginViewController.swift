//
//  LoginViewController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/29.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    
        let userField = UITextField(frame: CGRect(x: 100, y: 100, width: Device.width/2, height: 30))
        userField.borderStyle = .roundedRect
        userField.placeholder = "请输入用户名"
        userField.clearButtonMode = .always
        view.addSubview(userField)
        
        let passField = UITextField(frame: CGRect(x: 100, y: 160, width: Device.width/2, height: 30))
        passField.borderStyle = .roundedRect
        passField.placeholder = "请输入密码"
        passField.clearButtonMode = .always
        view.addSubview(passField)
        
        let button = UIButton(frame: CGRect(x: Device.width/2-25, y: 210, width: 50, height: 30))
        button.backgroundColor = .red
        button.setTitle("确定", for: .normal)
        button.addTarget(self, action: #selector(clickLogin), for: .touchUpInside)
        self.view.addSubview(button)
        
    }
    @objc func clickLogin() {
        print("按钮被点击了")
        
    }
    
}
