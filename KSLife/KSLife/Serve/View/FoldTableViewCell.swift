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
    case docForm = "docFormCell"
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
        let padding: CFloat = 15
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
            label.font = UIFont.systemFont(ofSize: 16)
            label.sizeToFit()
            label.snp.makeConstraints { make in
                make.top.equalTo(contentView).offset(padding)
                make.centerX.equalTo(contentView)
                make.bottom.equalTo(contentView).offset(-padding)
            }
        case .item:
            print("use the function convenience init(name: [String]) with item type")
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
            label.font = UIFont.systemFont(ofSize: 16)
            label.sizeToFit()
            label.snp.makeConstraints { make in
                make.top.equalTo(contentView).offset(padding)
                make.left.equalTo(contentView).offset(20)
                make.bottom.equalTo(contentView).offset(-padding)
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
            label.text = "\(name)"
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 13)
            label.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(5)
                make.centerX.equalTo(imageView)
                make.bottom.equalTo(contentView).offset(-50)
            }
        }
    }
    
    convenience init(with style: FoldCellStyle = .item, name: [String]) {
        self.init(style: .default, reuseIdentifier: style.rawValue)
        self.style = style
        
        let margin: CGFloat = 20
        self.textLabel?.text = name[0]
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        textLabel?.sizeToFit()
        let label = UILabel()
        contentView.addSubview(label)
        label.text = name[1]
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        label.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).offset(-margin)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
