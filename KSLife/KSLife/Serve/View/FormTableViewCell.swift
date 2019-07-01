//
//  FormTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class FormTableViewCell: UITableViewCell {
    
    private var name: String = "工作与睡眠健康问卷"

    private lazy var arrowView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "more_go")
        view.sizeToFit()
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = name
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    convenience init(name: String) {
        self.init(style: .default, reuseIdentifier: name)
        self.name = name
        label.text = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        let margin: CGFloat = 20
        let padding: CFloat = 15
        contentView.addSubview(arrowView)
        arrowView.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.right.equalTo(contentView).offset(-margin)
            make.centerY.equalTo(contentView)
        }
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(padding)
            make.left.equalTo(contentView).offset(margin)
            make.bottom.equalTo(contentView).offset(-padding)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
