//
//  PopView.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/23.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

private let length: CGFloat = 5

class PopView: UIView {
    private var origin: CGPoint
    private var width: CGFloat
    private var height: CGFloat
    
    private var backgroundView: UIView
    private var superView: UIView
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "饮食评分依据中国食品成分数据及专业营养摄入量建议，提供个性化的每日营养摄入分析"
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    init(origin: CGPoint, width: CGFloat, height: CGFloat, color: UIColor, superView: UIView) {
        self.origin = origin
        self.width = width
        self.height = height
        self.backgroundView = UIView(frame: CGRect(origin: origin, size: CGSize(width: width, height: height)))
        self.backgroundView.backgroundColor = color
        self.backgroundView.layer.cornerRadius = 15
        self.superView = superView
        super.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        
        self.backgroundColor = .clear
        addSubview(backgroundView)
        
        backgroundView.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.backgroundView).offset(15)
            make.left.equalTo(self.backgroundView).offset(15)
            make.bottom.equalTo(self.backgroundView).offset(-15)
            make.right.equalTo(self.backgroundView).offset(-15)
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        
        let context = UIGraphicsGetCurrentContext()
        
        let startX = self.origin.x
        let startY = self.origin.y
        context?.move(to: self.origin)
        
        context?.addLine(to: CGPoint(x: startX + length, y: startY + length))
        context?.addLine(to: CGPoint(x: startX - length, y: startY + length))
        
        context?.closePath()
        self.backgroundView.backgroundColor?.setFill()
        self.backgroundColor?.setStroke()
        context?.drawPath(using: .fillStroke)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopView {
    
    func popView() {
//        let subViews = self.backgroundView.subviews
//        for view in subViews {
//            view.isHidden = true
//        }
//        let windowView = UIApplication.shared.keyWindow
        superView.addSubview(self)
        
        self.backgroundView.frame = CGRect(x: origin.x, y: origin.y + length, width: 0, height: 0)
        let originX = origin.x - self.width / 2
        let originY = origin.y + length
        let width = self.width
        let height = self.height
        UIWindow.animate(withDuration: 0.25, animations: {
            self.backgroundView.frame = CGRect(x: originX, y: originY, width: width, height: height);
        }, completion: { _ in
            for view in self.backgroundView.subviews {
                view.isHidden = false
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if ((touches as NSSet).anyObject() as AnyObject).view != self.backgroundView {
            self.dismiss()
        }
    }
    
    func dismiss() {
        let subViews = self.backgroundView.subviews
        for view in subViews {
            view.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.backgroundView.frame = CGRect(x: self.origin.x, y: self.origin.y, width: 0, height: 0)
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
