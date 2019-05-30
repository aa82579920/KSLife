//
//  FoldTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/29.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

enum FoldCellStyle: String {
    case section = "sectionCell"
    case item = "itemCell"
    case docPlan = "docPlanCell"
    case docForm = "docFormCell"
    case docCircle = "docCircle"
    case none = "noneCell"
}

class FoldTableViewCell: UITableViewCell {

    var canUnfold = true {
        didSet {
            if self.canUnfold && style == .section {
                arrowView.image = UIImage(named: "more_go")
            } else {
                arrowView.image = UIImage(named: "more")
            }
        }
    }
    var name = ""
    let arrowView = UIImageView()
    var style: FoldCellStyle = .section
    
    convenience init(with style: FoldCellStyle, name: String) {
        self.init(style: .default, reuseIdentifier: style.rawValue)
        self.style = style
        
        let margin: CGFloat = 20
        switch style {
        case .section:
            arrowView.image = UIImage(named: self.canUnfold ? "more_go" : "more")
            arrowView.sizeToFit()
            self.contentView.addSubview(arrowView)
            arrowView.snp.makeConstraints { make in
                make.width.equalTo(15)
                make.height.equalTo(15)
                make.right.equalTo(contentView).offset(-10)
                make.centerY.equalTo(contentView)
            }
            
            let label = UILabel()
            self.contentView.addSubview(label)
            label.text = name
            label.font = UIFont.systemFont(ofSize: 15)
            label.sizeToFit()
            label.snp.makeConstraints { make in
                make.top.equalTo(contentView).offset(15)
                make.centerX.equalTo(contentView)
                make.bottom.equalTo(contentView).offset(-15)
            }
        case .item:
            self.textLabel?.text = name
            textLabel?.font = UIFont.systemFont(ofSize: 14)
            textLabel?.sizeToFit()
            let label = UILabel()
            contentView.addSubview(label)
            label.text = "毫克"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.sizeToFit()
            label.snp.makeConstraints { make in
                make.centerY.equalTo(contentView)
                make.right.equalTo(contentView).offset(-margin)
            }
        case .docPlan:
            let labelOne = UILabel()
            contentView.addSubview(labelOne)
            labelOne.text = "08月26日"
            labelOne.textAlignment = .center
            labelOne.font = UIFont.systemFont(ofSize: 15)
            labelOne.sizeToFit()
            labelOne.snp.makeConstraints { make in
                make.centerY.equalTo(contentView)
                make.left.equalTo(contentView).offset(margin)
                make.width.equalTo(contentView).multipliedBy(0.3)
            }
            let labelTwo = UILabel()
            contentView.addSubview(labelTwo)
            labelTwo.text = "08:26至08:30在北京"
            labelTwo.textAlignment = .center
            labelTwo.font = UIFont.systemFont(ofSize: 15)
            labelTwo.sizeToFit()
            labelTwo.numberOfLines = 0
            labelTwo.snp.makeConstraints { make in
                make.left.equalTo(labelOne.snp.right).offset(margin)
                make.height.equalTo(contentView)
                make.right.equalTo(contentView).offset(-margin)
            }
        case .docCircle:
            let margin: CGFloat = 20
            let labelOne = UILabel()
            contentView.addSubview(labelOne)
            labelOne.text = "文章"
            labelOne.textAlignment = .center
            labelOne.backgroundColor = mainColor
            labelOne.textColor = .white
            labelOne.font = UIFont.systemFont(ofSize: 15)
            labelOne.sizeToFit()
            labelOne.snp.makeConstraints { make in
                make.top.equalTo(contentView)
                make.left.equalTo(contentView).offset(40)
                make.width.equalTo(contentView).multipliedBy(0.1)
            }
            let labelTwo = UILabel()
            contentView.addSubview(labelTwo)
            labelTwo.text = "上海地区医生制作了新的调查问卷，快去体验一下吧"
            labelTwo.backgroundColor = UIColor(hex6: 0xdbdbdb)
            labelTwo.textColor = .black
            labelTwo.font = UIFont.systemFont(ofSize: 15)
            labelTwo.sizeToFit()
            labelTwo.numberOfLines = 0
            labelTwo.snp.makeConstraints { make in
                make.top.equalTo(labelOne.snp.bottom).offset(5)
                make.left.equalTo(labelOne.snp.right).offset(-5)
                make.width.equalTo(contentView).multipliedBy(0.6)
                make.bottom.equalTo(contentView).offset(-margin)
            }
            let labelThree = UILabel()
            contentView.addSubview(labelThree)
            labelThree.text = "1篇"
            labelThree.font = UIFont.systemFont(ofSize: 17)
            labelThree.sizeToFit()
            labelThree.numberOfLines = 0
            labelThree.snp.makeConstraints { make in
                make.centerY.equalTo(labelTwo)
                make.right.equalTo(contentView).offset(-margin)
            }
        case .docForm:
            arrowView.image = UIImage(named: "more_go")
            arrowView.sizeToFit()
            contentView.addSubview(arrowView)
            arrowView.snp.makeConstraints { make in
                make.width.equalTo(15)
                make.height.equalTo(15)
                make.right.equalTo(contentView).offset(-20)
                make.centerY.equalTo(contentView)
            }
            
            let label = UILabel()
            self.contentView.addSubview(label)
            label.text = "工作与睡眠健康问卷"
            label.font = UIFont.systemFont(ofSize: 15)
            label.sizeToFit()
            label.snp.makeConstraints { make in
                make.top.equalTo(contentView).offset(15)
                make.left.equalTo(contentView).offset(20)
                make.bottom.equalTo(contentView).offset(-15)
            }
        case .none:
            let imageView = UIImageView()
            contentView.addSubview(imageView)
            imageView.contentMode = .center
            imageView.image = UIImage(named: "emptyIcon")
            imageView.snp.makeConstraints { make in
                make.top.equalTo(contentView).offset(50)
                make.centerX.equalTo(contentView)
            }
            let label = UILabel()
            contentView.addSubview(label)
            label.text = "亲，没找到相关数据"
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 13)
            label.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.centerX.equalTo(imageView)
                make.bottom.equalTo(contentView).offset(-50)
            }
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
