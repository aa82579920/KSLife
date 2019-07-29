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
    case weight = "weightStyle"
}
let padding: CGFloat = 15
let margin: CGFloat = screenW * 0.05

class DayDishTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    private var dish: Dish?
    private var simpleDishs: SimpleDish?
    
    lazy var dishImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noImg")
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
    
    convenience init(with style: DayDishCellStyle = .normal, dish: Dish) {
        self.init(style: .default, reuseIdentifier: style.rawValue)
        self.style = style
        self.dish = dish
            contentView.addSubview(dishImage)
            contentView.addSubview(nameLabel)
            contentView.addSubview(weightLabel)
        switch style {
        case .normal:
            remakeNormalConstraints()
        case .weight:
            weightLabel.font = .systemFont(ofSize: 15, weight: .heavy)
            weightLabel.textColor = .black
            remakeWeightConstraints()
        default:
            break
        }
            dishImage.sd_setImage(with: URL(string: dish.icon), placeholderImage: UIImage(named: "noImg"))
            nameLabel.text = dish.name
            weightLabel.text = "\(dish.amount)克"
    }

    convenience init(with style: DayDishCellStyle = .simple, dish: SimpleDish) {
        self.init(style: .default, reuseIdentifier: style.rawValue)
        self.style = style
        self.simpleDishs = dish
        contentView.addSubview(dishImage)
        contentView.addSubview(nameLabel)
        remakeSimpleConstraints()
        
        dishImage.sd_setImage(with: URL(string: dish.icon ?? ""), placeholderImage: UIImage(named: "noImg"))
        nameLabel.text = dish.name
    }
    
    func remakeNormalConstraints() {
        
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
    
    func remakeWeightConstraints() {
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
        
        weightLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(dishImage)
            make.right.equalTo(contentView).offset(-padding)
        }
    }
    
    func remakeSimpleConstraints() {
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
