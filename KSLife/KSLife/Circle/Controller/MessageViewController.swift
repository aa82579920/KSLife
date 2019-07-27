//
//  MessageViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import MJRefresh

class MessageViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        var isTrues = true;
        if isFromList {
            isTrues = (recUid == nil || mid == nil) ? false : true;
        } else {
            isTrues = recUid == nil ? false : true;
        }
        
        if !isFromList {
            checkMessage(uid: UserInfo.shared.user.uid, recUid: recUid!, success: { list in
                self.mid = list[0].mid
                self.getMessage(mid: self.mid!, success: { list in
                    self.messages = list.reversed()
                })
            })
        } else {
            getMessage(mid: mid!, success: { list in
                self.messages = list.reversed()
            })
        }
        addTimer()
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self, refreshingAction: Selector(("getHistoryMsg")))
        header.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeTimer()
    }
    
    var replyTimer : Timer?
    
    var isFromList = false
    
    var mid: Int?
    
    var recUid: String?
    
    private var page: Int = 0
    
    private var messages: [Message] = [] {
        didSet {
            tableView.reloadData()
            if page == 0 {
                tableView.scrollToRow(at: IndexPath(row: tableView.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: false)
            }
        }
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
        let btn = NavButton(frame: .zero, title: "发送")
        btn.backgroundColor = mainColor
        btn.shadowBlur = 0
        btn.shadowOpacity = 0
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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageTableViewCell(style: .default, reuseIdentifier: messageTableViewCellID)
        if indexPath.row > 0 {
            if (messages[indexPath.row].time.toDate()!.date.timeIntervalSince1970 - messages[indexPath.row - 1].time.toDate()!.date.timeIntervalSince1970) < 60 {
                cell.isShowTime = false
            }
        }
        cell.setUpWithModel(message: messages[indexPath.row])
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
    
    private func addTimer(){
        replyTimer = Timer(timeInterval: 5, target: self, selector: #selector(getReply), userInfo: nil, repeats: true)
        RunLoop.main.add(replyTimer!, forMode: .common)
    }
    private func removeTimer(){
        replyTimer?.invalidate()
        replyTimer = nil
    }
    
    @objc func getReply() {
        let zone = NSTimeZone.local
        let interval = zone.secondsFromGMT()
        
        getNewReply(mid: mid!, sendUid: recUid!, beginTime: Date(timeIntervalSinceNow: -5).addingTimeInterval(TimeInterval(interval)).toFormat("yyyy-MM-dd HH:mm:ss", locale: Locale(identifier: "zh_CN")), success: { list in
            if list.count > 0 {
                self.messages += list
            }
        })
    }
    
    @objc func send() {
        if let content = textField.text {
            let recUid = messages[0].sender.uid == UserInfo.shared.user.uid ? messages[0].receiver!.uid : messages[0].sender.uid
            postMessage(sendUid: UserInfo.shared.user.uid, recUid: recUid, content: content, success: { msg in
                if msg == "OK" {
                    self.getMessage(mid: self.mid!, success: { list in
                        self.messages = list.reversed()
                    })
                    self.textField.text = ""
                } else {
                    print(msg)
                    self.tipWithLabel(msg: "消息发送失败")
                }
            })
        }
    }
    
    @objc func getHistoryMsg() {
        page += 1
        getMessage(mid: mid!, page: page, success: { list in
            self.messages = list.reversed() + self.messages
        })
        self.tableView.mj_header.endRefreshing()
    }
    
    func checkMessage(uid: String, recUid: String, success: @escaping ([Message]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: MsgAPIs.checkMessage, parameters: ["uid": uid, "recUid": recUid], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            if data.count > 0 {
                do {
                    let json = try JSONSerialization.data(withJSONObject: data, options: [])
                    let list = try JSONDecoder().decode([Message].self, from: json)
                    success(list)
                } catch {
                    print("error")
                }
            }
        }, failure: { _ in
            
        })
    }
    
    func getMessage(mid: Int, page: Int = 0, success: @escaping ([Message]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: MsgAPIs.getMessage, parameters: ["mid": "\(mid)", "page": "\(page)"], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            if data.count > 0 {
                do {
                    let json = try JSONSerialization.data(withJSONObject: data, options: [])
                    let list = try JSONDecoder().decode([Message].self, from: json)
                    success(list)
                } catch {
                    print("error")
                }
            }
        }, failure: { _ in
            
        })
    }
    
    func postMessage(sendUid: String, recUid: String, content: String, time: String = "", success: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: MsgAPIs.postMessage, parameters: ["sendUid": sendUid, "recUid": recUid, "content": content], success: { dict in
            guard let msg = dict["msg"] as? String else {
                return
            }
            success(msg)
        }, failure: { _ in
            
        })
    }
    
    func getNewReply(mid: Int, sendUid: String, beginTime: String, success: @escaping ([Message]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: MsgAPIs.getNewReply, parameters: ["mid": "\(mid)", "sendUid": sendUid, "beginTime": beginTime], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: [])
                let list = try JSONDecoder().decode([Message].self, from: json)
                success(list)
            } catch {
                print("error")
            }
        }, failure: { _ in
            
        })
    }
}
