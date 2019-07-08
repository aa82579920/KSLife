//
//  SetMealTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/8.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class SetMealTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dishImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(button)
        remakeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var meal: SetMeal? {
        didSet {
            if let meal = meal {
                nameLabel.text = meal.setName
                dishImage.sd_setImage(with: URL(string: meal.icon), placeholderImage: UIImage(named: "noImg"))
            }
        }
    }
    
    private lazy var dishImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "scenery")
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "红烧肉"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more_go"), for: .normal)
        return button
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func remakeConstraints() {
        let padding: CGFloat = 15
        let margin: CGFloat = screenW * 0.05
        
        dishImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(padding)
            make.left.equalTo(contentView).offset(margin)
            make.bottom.equalTo(contentView).offset(-padding)
            make.width.equalTo(dishImage.snp.height)
        }
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(dishImage).offset(padding)
            make.left.equalTo(dishImage.snp.right).offset(margin)
        }
        
        button.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
            make.right.equalToSuperview().offset(-padding)
        }
    }

}
