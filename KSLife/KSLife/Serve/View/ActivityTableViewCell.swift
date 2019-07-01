//
//  ActivityTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    private var activity: Activity? 

    private lazy var labelOne: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    private lazy var labelTwo: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    convenience init(activity: Activity) {
        self.init(style: .default, reuseIdentifier: activity.place)
        self.activity = activity
        setUpText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {
        let margin: CGFloat = 20
        let padding: CGFloat = 5
        contentView.addSubview(labelOne)
        labelOne.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(padding)
            make.left.equalTo(contentView).offset(margin)
            make.width.equalTo(contentView).multipliedBy(0.3)
        }
        contentView.addSubview(labelTwo)
        labelTwo.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(padding)
            make.bottom.equalTo(contentView).offset(-padding)
            make.left.equalTo(labelOne.snp.right).offset(margin)
            make.right.equalTo(contentView).offset(-margin)
        }
    }
    
     func setUpText() {
        if let activity = activity {
            let intervalBg = TimeInterval.init(activity.beginTime)
            let dateBg = Date(timeIntervalSinceNow: intervalBg)
            let intervalEnd = TimeInterval.init(activity.endTime)
            let dateEnd = Date(timeIntervalSinceNow: intervalEnd)
            labelOne.text = "\(dateBg.month)月\(dateBg.day)日"
            labelTwo.text = "\(dateBg.hour):\(dateBg.minute)至\(dateEnd.hour):\(dateEnd.minute)在\(activity.place)"
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
