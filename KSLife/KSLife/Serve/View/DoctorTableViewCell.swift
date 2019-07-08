//
//  DoctorTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class DoctorTableViewCell: CommentTableViewCell {
    
    var doctor: Doctor? {
        didSet {
            if let doctor = doctor {
                details = [doctor.name, "收到鲜花数\(doctor.likeNum)", doctor.hospital + "  " + doctor.level + "\n" + doctor.introduction]
                avatarImage.sd_setImage(with: URL(string: doctor.photo), placeholderImage: UIImage(named: "noImg"))
                switch doctor.follow {
                case 0:
                    statusLabel.isHidden = true
                case 1:
                    statusLabel.isHidden = false
                    statusLabel.backgroundColor = UIColor(hex6: 0xf0ad4e)
                    statusLabel.text = "待签约"
                case 2:
                    statusLabel.isHidden = false
                    statusLabel.backgroundColor = mainColor
                    statusLabel.text = "已签约"
                default:
                    break
                }
            }
        }
    }
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        fontSize = [16, 15, 14]
        details = ["天津地区医生", "收到鲜花数：321", "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"]
        contentView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) -> Void in
            make.top.right.equalTo(avatarImage)
            make.width.equalTo(avatarImage).multipliedBy(0.8)
            make.height.equalTo(20)
        }
    }
    
    override func remakeConstraints() {
        avatarImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(margin)
            make.left.equalTo(contentView).offset(margin)
            make.width.equalTo(contentView).multipliedBy(0.2)
            make.height.equalTo(avatarImage.snp.width)
        }
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(avatarImage)
            make.left.equalTo(avatarImage.snp.right).offset(padding)
        }
        
        timeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel)
            make.right.equalTo(contentView).offset(-margin)
        }
        
        detailLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(margin)
            make.right.equalTo(timeLabel)
            make.bottom.equalTo(contentView).offset(-margin)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
