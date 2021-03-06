//
//  MessageFriendsViewConttroller.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/25.
//  Copyright © 2019 王春杉. All rights reserved.
//
// 我的消息 食友页面
import UIKit
class MessageFriendsViewConttroller: MessageDoctorViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages(uid: UserInfo.shared.user.uid, type: 1, success: { list in
            self.msgList = list
        })
    }
    
    @objc override func refresh() {
        getMessages(uid: UserInfo.shared.user.uid, type: 1, success: { list in
            self.msgList = list
        })
        self.tableView.mj_header.endRefreshing()
    }
}

