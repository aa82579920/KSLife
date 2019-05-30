//
//  MsgTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class MsgTableViewCell: UITableViewCell {
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "scenery")
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
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var throughLabel: UILabel = {
        let label = UILabel()
        label.text = "1天23小时"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "津南区"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var favBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("+关注", for: .normal)
        btn.setTitle("已关注", for: .selected)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.white, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.backgroundColor = .white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.lightGray.cgColor
        btn.addTarget(self, action: #selector(toFav), for: .touchUpInside)
        return btn
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var detailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "scenery")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(throughLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(detailImage)
        contentView.addSubview(favBtn)
        remakeConstraints()
        
//                layoutIfNeeded()
//        
//                detailImage.addCorner(roundingCorners: [.topRight, .topLeft, .bottomLeft, .bottomRight], cornerSize: CGSize(width: avatarImage.frame.height * 0.5, height: avatarImage.frame.height * 0.5))
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

extension MsgTableViewCell {
    
    @objc func toFav() {
        favBtn.isSelected = !favBtn.isSelected
        favBtn.backgroundColor = favBtn.isSelected ? mainColor : UIColor.white
    }
    
    func remakeConstraints() {
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
            make.bottom.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(margin)
        }
        
        throughLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(avatarImage)
            make.top.equalTo(avatarImage.snp.bottom).offset(5)
        }
        
        addressLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(avatarImage)
            make.top.equalTo(throughLabel.snp.bottom).offset(10)
        }
        
        favBtn.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(detailImage.snp.left).offset(-5)
            make.top.equalTo(contentView).offset(5)
            make.width.equalTo(50)
            make.height.equalTo(25)
        }
        
        detailLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(padding)
            make.bottom.equalTo(contentView).offset(-margin)
        }
        
        detailImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(screenW * 0.2)
            make.height.equalTo(detailImage.snp.width)
            make.right.equalTo(contentView).offset(-padding)
            make.left.equalTo(detailLabel.snp.right).offset(margin)
            make.centerY.equalTo(contentView)
        }
        
    }
}
