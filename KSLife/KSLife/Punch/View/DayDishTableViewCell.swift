//
//  dayDishTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/23.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

enum DayDishCellStyle: String {
    case simple = "simpleStyle"
    case normal = "normalStyle"
}

class DayDishTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    private lazy var dishImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "scenery")
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "红烧肉"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.black
        return label
    }()

    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.text = "50克"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private var style: DayDishCellStyle = .normal
    
    convenience init(with style: DayDishCellStyle) {
        self.init(style: .default, reuseIdentifier: style.rawValue)
        self.style = style
        
        switch style {
        case .normal:
            contentView.addSubview(dishImage)
            contentView.addSubview(nameLabel)
            contentView.addSubview(weightLabel)
            remakeNormalConstraints()
        case .simple:
            contentView.addSubview(dishImage)
            contentView.addSubview(nameLabel)
            remakeSimpleConstraints()
        }
    }
    
    func remakeNormalConstraints() {
        let padding: CGFloat = 15
        let margin: CGFloat = contentView.frame.width * 0.05
        
        dishImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(padding)
            make.left.equalTo(contentView).offset(margin)
            make.bottom.equalTo(contentView).offset(-padding)
            make.width.equalTo(dishImage.snp.height)
        }
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dishImage)
            make.left.equalTo(dishImage.snp.right).offset(margin)
        }
        
        weightLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(padding)
            make.left.equalTo(nameLabel)
        }
    }
    
    func remakeSimpleConstraints() {
        let padding: CGFloat = 15
        let margin: CGFloat = contentView.frame.width * 0.05
        
        dishImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(padding)
            make.left.equalTo(contentView).offset(margin)
            make.bottom.equalTo(contentView).offset(-padding)
            make.width.equalTo(dishImage.snp.height)
        }
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(dishImage)
            make.left.equalTo(dishImage.snp.right).offset(margin)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
