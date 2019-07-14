//
//  NavButton.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class NavButton: UIButton {
    var shadowBlur: CGFloat = 2 { 
        didSet {
            self.layer.shadowRadius = shadowBlur
        }
    }
    
    var shadowOpacity: Float = 0.3 { // 0.6
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }

    var shadowColor: UIColor = UIColor.gray {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    var cardRadius: CGFloat = 5 {
        didSet {
            self.layer.cornerRadius = cardRadius
        }
    }
    
    init(frame: CGRect, backgroundColor: UIColor, titleColor: UIColor, title: String) {
        super.init(frame: frame)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = cardRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowBlur
    }
    
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame, backgroundColor: mainColor, titleColor: .white, title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

   
}
