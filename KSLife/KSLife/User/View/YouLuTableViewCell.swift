//
//  YouLuTableViewCell.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/19.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
// 友录cell
class YouLuTableViewCell: UITableViewCell {
    let headImageView = UIImageView()
    let nameLable = UILabel()
    let discribLable = UILabel()
    let numLable = UILabel()
    let jianTouImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(index: Int) {
        self.init(style: .default, reuseIdentifier: "YouLuTableViewCell")
        let padding: CGFloat = 20
        
        headImageView.frame = CGRect(x: padding, y: padding, width: 50, height: 50)
        headImageView.image = UIImage(named: "upic")
        headImageView.layer.masksToBounds = true
        headImageView.layer.cornerRadius = headImageView.frame.width/2
        contentView.addSubview(headImageView)
        
        nameLable.frame = CGRect(x: headImageView.frame.maxX + padding, y: padding, width: Device.width/3, height: 25)
        nameLable.font = UIFont.systemFont(ofSize: 17)
        nameLable.text = "结束吧"
        nameLable.textColor = .black
        contentView.addSubview(nameLable)
        
        discribLable.frame = CGRect(x: nameLable.frame.minX, y: nameLable.frame.maxY+5, width: Device.width/2, height: 15)
        discribLable.font = UIFont.systemFont(ofSize: 12)
        discribLable.textColor = .gray
        discribLable.text = "我是呵呵呵呵"
        contentView.addSubview(discribLable)
        
        numLable.frame = CGRect(x: nameLable.frame.minX, y: discribLable.frame.maxY + 5, width: Device.width*2/3, height: 15)
        numLable.font = UIFont.systemFont(ofSize: 15)
        numLable.textColor = .gray
        numLable.text = "康食号:102488221234123456"
        contentView.addSubview(numLable)
        
        jianTouImageView.frame = CGRect(x: Device.width-25, y: 40, width: 20, height: 20)
        jianTouImageView.image = UIImage(named: "youjiantou")
        contentView.addSubview(jianTouImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
