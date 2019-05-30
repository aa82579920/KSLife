//
//  DetailMsgTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/10.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class DetailMsgTableViewCell: UITableViewCell {

    private let titles = ["姓名：", "收到鲜花：", "医院：", "工作经验：", "职称：", "简介："]
    private let details = ["上海地区医生", "6004268", "上海第一人民医院", "7年工作经验", "副主任医师", "胃肠肝胆胰手术前后、肿瘤、放化疗、胰腺炎、脂肪泻、消瘦等疾病的营养干预和治疗。多次获得奖励,发表专业相关文章多篇,尤其擅长根据个体疾病特点及生理阶段为不同病患提供个性化的营养咨询和饮食指导。初诊时间:每周五上午:9:00-12:00"]
    private var titleLabels: [UILabel] = []
    private var detailLabels: [UILabel] = []
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("送花", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 5
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        remakeConstraints()
    }
    
    func setUpUI() {
        for i in 0..<6 {
            let titleLabel = UILabel()
            titleLabel.text = titles[i]
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.textAlignment = .right
            titleLabels.append(titleLabel)
            
            let detailLabel = UILabel()
            detailLabel.text = details[i]
            detailLabel.font = UIFont.systemFont(ofSize: 16)
            detailLabel.textAlignment = .left
            detailLabels.append(detailLabel)
            
            contentView.addSubview(titleLabels[i])
            contentView.addSubview(detailLabels[i])
        }
        
        detailLabels[0].font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        detailLabels[5].numberOfLines = 0
        contentView.addSubview(button)
    }
    
    func remakeConstraints() {
        let margin: CGFloat = 15
        
        for i in 0..<6 {
            titleLabels[i].snp.makeConstraints { (make) -> Void in
                make.left.equalTo(contentView).offset(margin)
                make.width.equalTo(contentView).multipliedBy(0.25)
            }
            
            detailLabels[i].snp.makeConstraints { (make) -> Void in
                make.left.equalTo(titleLabels[0].snp.right).offset(margin)
                make.centerY.equalTo(titleLabels[i])
            }
        }
        
        titleLabels[0].snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(margin)
        }

        for i in 1..<6 {
            titleLabels[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(titleLabels[i - 1].snp.bottom).offset(margin)
            }
            
            detailLabels[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(detailLabels[i - 1].snp.bottom).offset(margin)
                make.right.equalTo(contentView).offset(-margin)
            }
        }
        
        detailLabels[5].snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(contentView).offset(-margin)
        }
        
        button.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(detailLabels[0])
            make.bottom.equalTo(detailLabels[0])
            make.left.equalTo(detailLabels[0].snp.right).offset(margin)
            make.width.equalTo(contentView).multipliedBy(0.14)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
