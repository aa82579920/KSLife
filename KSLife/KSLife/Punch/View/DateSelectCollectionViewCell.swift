//
//  DateSelectCollectionViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/31.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import SwiftDate

class DateSelectCollectionViewCell: UICollectionViewCell {
   
    private let dayWidth: CGFloat = 25
    
    lazy var dayBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.white, for: .selected)
        btn.setBackgroundImage(UIImage(color: mainColor), for: .selected)
        btn.setBackgroundImage(UIImage(color: .clear), for: .normal)
        btn.layer.cornerRadius = dayWidth / 2
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.clipsToBounds = true
        btn.isUserInteractionEnabled = false
        btn.layer.borderColor = mainColor.cgColor
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(dayBtn)
        dayBtn.snp.makeConstraints { make in
            make.width.height.equalTo(dayWidth)
            make.center.equalTo(contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillDataWithDate(date: Date) {
        dayBtn.setTitle("\(date.day)", for: .normal)
        if date.isToday {
            self.dayBtn.layer.borderWidth = 1
        } else {
            self.dayBtn.layer.borderWidth = 0
        }
        if date.isAfterDate(Date(), granularity: .day) {
            self.isUserInteractionEnabled = false
            dayBtn.setTitleColor(.lightGray, for: .normal)
        }
    }
}

