//
//  LoginViewController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/29.
//  Copyright © 2019 王春杉. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpUI()
        remakeConstraints()
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "康食"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        label.textColor = .white
        label.backgroundColor = mainColor
        return label
    }()
    
    private lazy var userField: UITextField = { [weak self] in
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "请输入用户名"
        field.clearButtonMode = .always
        field.delegate = self
        field.returnKeyType = .next
        return field
        }()
    
    private lazy var passField: UITextField = { [weak self] in
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "请输入密码"
        field.clearButtonMode = .always
        field.autocapitalizationType = .none
        field.isSecureTextEntry = true
        field.delegate = self
        return field
        }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = mainColor
        button.setTitle("登录", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(clickLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var resetPass: UIButton = {
        let btn = UIButton()
        btn.setTitle("忘记密码", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return btn
    }()
    
    private lazy var noAccount: UILabel = {
        let label = UILabel()
        label.text = "没有账号？"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    
    private lazy var signInBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = mainColor
        button.setTitle("去注册>>", for: .normal)
        button.setTitleColor(mainColor, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var wxBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "weixin"), for: .normal)
        button.layer.cornerRadius = view.bounds.width * 0.05
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(wechat), for: .touchUpInside)
        return button
    }()
    
    
    @objc func clickLogin() {

        passField.resignFirstResponder()
        userField.resignFirstResponder()
        
        guard let userId = userField.text, let password = passField.text else {
            tipWithLabel(msg: "请输入用户名密码")
            return
        }
        
        if userId.count == 0 {
            tipWithLabel(msg: "手机号不能为空")
        } else if password.count == 0 {
            tipWithLabel(msg: "密码不能为空")
        } else {
            UserInfo.shared.setUserInfo(mobile: userId, password: password, success: {
                UserInfo.shared.status = true
                UserDefaults.standard.set(password, forKey: LoginInfo().token)
                UserDefaults.standard.set(userId,forKey: LoginInfo().userId)
                
                UIApplication.shared.keyWindow?.rootViewController = MainTabBarController()
                self.present(MainTabBarController(), animated: true, completion: nil)
            }, failure: {
                self.tipWithLabel(msg: "用户名不存在或密码错误")
            })
        }
    }
    
    @objc func reset() {
        let vc = UINavigationController(rootViewController: ResetPassViewController())
        vc.hidesBottomBarWhenPushed = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func signIn() {
        let vc = UINavigationController(rootViewController: SignInViewController())
        vc.hidesBottomBarWhenPushed = true
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func wechat() {
        // 没安装客户端不跳转
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "default_state"
        
        WXApi.send(req)
        print("click wechat_login")
    }
    
    func setUpUI() {
        view.addSubview(label)
        view.addSubview(userField)
        view.addSubview(passField)
        view.addSubview(button)
        view.addSubview(resetPass)
        view.addSubview(signInBtn)
        view.addSubview(noAccount)
        view.addSubview(wxBtn)
    }
    
    func remakeConstraints() {
        let margin: CGFloat = 30
        label.snp.makeConstraints { make in
            make.top.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.25)
        }
        userField.snp.makeConstraints {make in
            make.top.equalTo(label.snp.bottom)
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.08)
        }
        passField.snp.makeConstraints {make in
            make.top.equalTo(userField.snp.bottom)
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.08)
        }
        button.snp.makeConstraints {make in
            make.top.equalTo(passField.snp.bottom)
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.05)
        }
        resetPass.snp.makeConstraints {make in
            make.top.equalTo(button.snp.bottom).offset(margin)
            make.left.equalTo(view).offset(margin)
            make.width.equalTo(view).multipliedBy(0.2)
        }
        signInBtn.snp.makeConstraints {make in
            make.centerY.equalTo(resetPass)
            make.right.equalTo(view).offset(-margin)
            make.width.equalTo(view).multipliedBy(0.2)
        }
        noAccount.snp.makeConstraints {make in
            make.right.equalTo(signInBtn.snp.left).offset(-10)
            make.centerY.equalTo(signInBtn)
            make.width.equalTo(view).multipliedBy(0.25)
        }
        wxBtn.snp.makeConstraints {make in
            make.top.equalTo(resetPass).offset(2 * margin)
            make.centerX.equalTo(view)
            make.width.height.equalTo(view.bounds.width * 0.1)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passField.resignFirstResponder()
        userField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
