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
                details = [doctor.name, "收到鲜花数\(doctor.likeNum)", doctor.introduction]
                avatarImage.sd_setImage(with: URL(string: doctor.photo), placeholderImage: UIImage(named: "noImg"))
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        fontSize = [16, 15, 14]
        details = ["天津地区医生", "收到鲜花数：321", "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
