//
//  CircleTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class CircleTableViewCell: UITableViewCell {
    
    var doctorName = ""
    
    private var circle: Circle?
    
    private let insert = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private lazy var labelOne: InsertLabel = {
        let label = InsertLabel(frame: .zero, textInsets: insert)
        label.textAlignment = .center
        label.backgroundColor = mainColor
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
     private lazy var labelTwo: InsertLabel = {
        let label = InsertLabel(frame: .zero, textInsets: insert)
        label.backgroundColor = UIColor(hex6: 0xdbdbdb)
        label.textColor = .black
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    private lazy var labelThree: InsertLabel = {
        let label = InsertLabel(frame: .zero, textInsets: insert)
        label.font = UIFont.systemFont(ofSize: 17)
        label.sizeToFit()
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    convenience init(name: String, circle: Circle) {
        self.init(style: .default, reuseIdentifier: circle.type)
        self.doctorName = name
        self.circle = circle
        setUpText()
        contentView.layoutIfNeeded()
        labelTwo.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        let margin: CGFloat = 20
        let padding: CGFloat = 5
        contentView.addSubview(labelOne)
        labelOne.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(2 * margin)
            make.width.equalTo(contentView).multipliedBy(0.15)
            make.height.equalTo(labelOne.snp.width).multipliedBy(0.5)
        }
        contentView.addSubview(labelTwo)
        labelTwo.snp.makeConstraints { make in
            make.top.equalTo(labelOne.snp.bottom).offset(padding)
            make.left.equalTo(labelOne.snp.right).offset(-padding)
            make.width.equalTo(contentView).multipliedBy(0.5)
            make.bottom.equalTo(contentView).offset(-margin)
        }
        contentView.addSubview(labelThree)
        labelThree.snp.makeConstraints { make in
            make.centerY.equalTo(labelTwo)
            make.right.equalTo(contentView).offset(-margin)
        }
    }
    
    func setUpText() {
        if let circle = circle {
            switch circle.type {
            case CircleType.article.rawValue:
                labelOne.text = "文章"
                labelTwo.text = "\(doctorName)在主编推荐中发表了\(circle.content!)"
                labelThree.text = "\(circle.count)篇"
            case CircleType.survey.rawValue:
                labelOne.text = "问卷"
                labelTwo.text = "\(doctorName)制作了新的调查问卷\(circle.content!)快去体验一下吧"
                labelThree.text = "\(circle.count)篇"
            case CircleType.flower.rawValue:
                labelOne.text = "鲜花"
                labelTwo.text = "\(circle.content ?? "")送花\(circle.single!)朵"
                labelThree.text = "\(circle.count)朵"
            case CircleType.contract.rawValue:
                labelOne.text = "签约"
                labelTwo.text = "\(circle.content ?? "")与\(doctorName)签约成功"
                labelThree.text = "\(circle.count)位"
            case CircleType.course.rawValue:
                labelOne.text = "课程"
                labelTwo.text = "\(doctorName)已经发布了新的课程\(circle.content ?? "")快去试一下吧"
                labelThree.text = "\(circle.count)篇"
            default:
                break
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
