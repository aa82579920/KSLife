//
//  MessageDoctorTableViewCell.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/25.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import SwiftDate

class MessageDoctorTableViewCell: UITableViewCell {
    
    let headImageView = UIImageView()
    let nameLable = UILabel()
    let contentLable = UILabel()
    let dayLable = UILabel()
    let countLable = UILabel()
    
    var msg: Message? {
        didSet {
            if let msg = msg {
                if msg.sender.uid != UserInfo.shared.user.uid {
                    nameLable.text = msg.sender.nickname ?? "康食君"
                    headImageView.sd_setImage(with: URL(string: msg.sender.photo ?? ""), placeholderImage: UIImage(named: "upic"))
                } else {
                    nameLable.text = msg.receiver!.nickname ?? "康食君"
                    headImageView.sd_setImage(with: URL(string: msg.receiver!.photo ?? ""), placeholderImage: UIImage(named: "upic"))
                }
                contentLable.text = msg.content
                let text = Date.compareCurrntTime(timeStamp: msg.time.toDate()!.date.timeIntervalSince1970)
                dayLable.text = text
                countLable.text = "\(msg.number)"
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(index: Int) {
        self.init(style: .default, reuseIdentifier: "MessageDoctorTableViewCell")
        let padding: CGFloat = 20
        // 头像
        headImageView.frame = CGRect(x: padding, y: padding, width: 50, height: 50)
        headImageView.image = UIImage(named: "upic")
        headImageView.layer.masksToBounds = true
        headImageView.layer.cornerRadius = headImageView.frame.width/2
        contentView.addSubview(headImageView)
        
        nameLable.frame = CGRect(x: headImageView.frame.maxX + padding, y: padding, width: Device.width/3, height: 25)
        nameLable.font = UIFont.systemFont(ofSize: 18)
        nameLable.text = "天津地区医生"
        nameLable.textColor = .black
        contentView.addSubview(nameLable)
        
        contentLable.frame = CGRect(x: nameLable.frame.minX, y: nameLable.frame.maxY+8, width: Device.width/2, height: 15)
        contentLable.font = UIFont.systemFont(ofSize: 14)
        contentLable.textColor = .gray
        contentLable.text = "我是呵呵呵呵"
        contentView.addSubview(contentLable)
        
        dayLable.frame = CGRect(x: Device.width-120, y: padding, width: 100, height: 25)
        dayLable.font = UIFont.systemFont(ofSize: 15)
        dayLable.textColor = .gray
        dayLable.text = "67天前"
        dayLable.textAlignment = .right
        contentView.addSubview(dayLable)
        
        countLable.frame = CGRect(x: Device.width-55, y: dayLable.frame.maxY + 10, width: 20, height: 20)
        countLable.layer.masksToBounds = true
        countLable.layer.cornerRadius = countLable.frame.width/2
        countLable.backgroundColor = UIColor.lightGray
        countLable.textColor = .black
        countLable.text = "0"
        countLable.textAlignment = .center
        contentView.addSubview(countLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
