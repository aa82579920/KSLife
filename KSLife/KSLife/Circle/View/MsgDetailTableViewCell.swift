//
//  MsgDetailTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/8.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class MsgDetailTableViewCell: UITableViewCell {
    
    
    var fontSize: [CGFloat] = [13, 13, 14] {
        didSet {
            nameLabel.font = UIFont.systemFont(ofSize: fontSize[0])
            timeLabel.font = UIFont.systemFont(ofSize: fontSize[1])
            detailLabel.font = UIFont.systemFont(ofSize: fontSize[2])
        }
    }
    
    var details: [String] = ["", "", ""] {
        didSet {
            nameLabel.text = details[0]
            timeLabel.text = details[1]
            detailLabel.text = details[2]
        }
    }

    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "王毛线"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "2019-05-01"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(detailLabel)
        remakeConstraints()
        
        avatarImage.image = UIImage(named: "scenery")
        
//        contentView.layoutIfNeeded()
//        
//        avatarImage.addCorner(roundingCorners: [.topRight, .topLeft, .bottomLeft, .bottomRight], cornerSize: CGSize(width: avatarImage.frame.height * 0.5, height: avatarImage.frame.height * 0.5))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MsgDetailTableViewCell {
    
    private func remakeConstraints() {
        let padding: CGFloat = 15
        let margin: CGFloat = contentView.frame.width * 0.05
        
        avatarImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(margin)
            make.left.equalTo(contentView).offset(margin)
            make.width.equalTo(contentView).multipliedBy(0.1)
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
}

