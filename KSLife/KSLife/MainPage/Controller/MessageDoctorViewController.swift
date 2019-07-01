//
//  MessageDoctorViewController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/25.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
class MessageDoctorViewController: UIViewController {
    
    var msgList: [Message] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        getMessages(uid: UserInfo.shared.user.uid, type: 2, success: { list in
            self.msgList = list
        })
    }
    
    func setTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getMessages(uid: String, type: Int, page: Int = 0, success: @escaping ([Message]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: MsgAPIs.getMessages, parameters: ["uid": uid, "type": "\(type)", "page": "\(page)"], success: { dict in
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

extension MessageDoctorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageDoctorTableViewCell(index: indexPath.row)
        cell.selectionStyle = .none
        cell.msg = msgList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MessageViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
