//
//  CourseTableViewCell.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/25.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
// 课程cell
class CourseTableViewCell: UITableViewCell {
    let headImageView = UIImageView()
    let nameLable = UILabel()
    let timeImageView = UIImageView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(index: Int) {
        self.init(style: .default, reuseIdentifier: "CourseTableViewCell")
        let padding: CGFloat = 20
        
        headImageView.frame = CGRect(x: padding, y: padding, width: 50, height: 50)
        headImageView.image = UIImage(named: "touxiang")
        headImageView.layer.masksToBounds = true
        headImageView.layer.cornerRadius = 10
        contentView.addSubview(headImageView)
        
        nameLable.frame = CGRect(x: headImageView.frame.maxX + padding, y: padding, width: Device.width*3/4, height: 25)
        nameLable.font = UIFont.systemFont(ofSize: 18)
        nameLable.text = "如何估算自己每天吃的食物重量"
        nameLable.textColor = .black
        contentView.addSubview(nameLable)
        
        timeImageView.frame = CGRect(x: nameLable.frame.minX, y: nameLable.frame.maxY + 10, width: 20, height: 20)
        timeImageView.image = UIImage(named: "duigoulan")
        timeImageView.layer.masksToBounds = true
        timeImageView.layer.cornerRadius = 10
        contentView.addSubview(timeImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
