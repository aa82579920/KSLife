//
//  MessageViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class MessageViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    private let sendViewH: CGFloat = 60
    private let messageTableViewCellID = "messageTableViewCellID"
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 100
        tableView.sectionFooterHeight = 20
        tableView.sectionHeaderHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: messageTableViewCellID)
        return tableView
        }()
    
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "（仅支持文字输入）"
        view.delegate = self
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = mainColor
        btn.setTitle("发送", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        btn.addTarget(self, action: #selector(send), for: .touchUpInside)
        return btn
    }()
    
    private lazy var sendView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableViewCell(style: .default, reuseIdentifier: messageTableViewCellID)
        cell.setUpWithModel()
        return cell
    }
}

extension MessageViewController: UITextFieldDelegate, UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyBoardWillShow(notifi:NSNotification)
    {
        
        let keyBoardBounds = (notifi.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration =  (notifi.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        
        let animations:(() -> Void) = {
            
            self.sendView.transform = CGAffineTransform(translationX: 0,y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIView.AnimationOptions(rawValue: UInt((notifi.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    @objc func keyBoardWillHide(notifi:NSNotification)
    {
        
        let duration =  (notifi.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]as! NSNumber).doubleValue
        
        
        let animations:(() -> Void) = {
            self.sendView.transform = CGAffineTransform.identity
            self.view.layoutIfNeeded()
        }
        
        if duration > 0 {
            let options = UIView.AnimationOptions(rawValue: UInt((notifi.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    
}

extension MessageViewController {
    
    func setUpUI(){
        sendView.addSubview(textField)
        sendView.addSubview(sendButton)
    
        view.addSubview(tableView)
        view.addSubview(sendView)
        
        remakeConstraints()
    }
    
    func remakeConstraints() {
        let margin: CGFloat = 20
        let padding: CGFloat = 10
        
        textField.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(sendView).offset(margin)
            make.width.equalTo(sendView).multipliedBy(0.75)
            make.bottom.equalTo(sendView).offset(-padding)
            make.top.equalTo(sendView).offset(padding)
        }
        
        sendButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(textField.snp.right).offset(padding)
            make.top.equalTo(sendView).offset(padding)
            make.bottom.right.equalTo(sendView).offset(-padding)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.top.equalTo(view)
        }
        
        sendView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(sendViewH)
            make.width.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    func setUpNav(_ animated: Bool){
        self.title = "消息"
        
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
}

extension MessageViewController {
    @objc func send() {
        
    }
}
