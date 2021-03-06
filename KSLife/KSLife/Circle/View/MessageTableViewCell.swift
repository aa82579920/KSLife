//
//  MessageTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/2.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    private var isComing = false
    
    var isShowTime = true
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "upic")
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerRadius = 22.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var timeLabel: InsertLabel = {
        let label = InsertLabel(frame: .zero, textInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        label.text = "07-02 16:10:05"
        label.textColor = .white
        label.backgroundColor = .lightGray
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "康食君"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "哈哈哈哈哈哈"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textBackgroundImageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    func setUpWithModel(message: Message) {
        contentView.addSubview(avatarImage)
        contentView.addSubview(nameLabel)
        if isShowTime {
            contentView.addSubview(timeLabel)
        }
        contentView.addSubview(textBackgroundImageView)
        contentView.addSubview(detailLabel)
        
        if isShowTime {
            timeLabel.text = message.time
            timeLabel.snp.makeConstraints { (make) in
                make.top.equalTo(contentView).offset(10)
                make.height.equalTo(20)
                make.centerX.equalTo(contentView)
            }
        }
        avatarImage.sd_setImage(with: URL(string: message.sender.photo ?? ""), placeholderImage: UIImage(named: "upic"))
        nameLabel.text = message.sender.nickname ?? "康食君"
        detailLabel.text = message.content
        isComing = message.sender.uid == UserInfo.shared.user.uid ? false : true
        detailLabel.textColor = isComing ? .black : .white
        textBackgroundImageView.backgroundColor = isComing ? .white : mainColor
        
        avatarImage.snp.makeConstraints { (make) in
            if isComing {
                make.left.equalTo(contentView).offset(10)
            } else {
                make.right.equalTo(contentView).offset(-10)
            }
            if isShowTime{ make.top.equalTo(timeLabel.snp.bottom).offset(10)
            } else {
                make.top.equalTo(contentView).offset(10)
            }
            make.width.height.equalTo(45)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(avatarImage)
            make.height.equalTo(15)
            if isComing {
                make.left.equalTo(avatarImage.snp.right).offset(20)
            } else {
                make.right.equalTo(avatarImage.snp.left).offset(-20)
            }
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.width.lessThanOrEqualTo(220)
            make.bottom.equalTo(contentView).offset(-20)
            if isComing {
                make.left.equalTo(avatarImage.snp.right).offset(20)
            } else {
                make.right.equalTo(avatarImage.snp.left).offset(-20)
            }
        }
        
        textBackgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(detailLabel).offset(-10)
            make.left.equalTo(detailLabel).offset(-10)
            make.right.equalTo(detailLabel).offset(10)
            make.bottom.equalTo(detailLabel).offset(10)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
