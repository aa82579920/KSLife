//
//  PopBaseView.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/6.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

/*弹框的基础图*/
import UIKit
class PopBaseView: UIView ,UIGestureRecognizerDelegate{
    //白色view用来装一些控件
    var WhiteView = UIView()
    var whiteViewStartFrame = CGRect(x: screenW/2 - 10, y: screenH/2 - 10, width: 20, height: 20)
    var whiteViewEndFrame = CGRect(x: 40, y: 100, width: screenW - 80, height: screenH - 230)
    //取消按钮
    var cancelBtn: UIButton = UIButton()
    //背景区域的颜色和透明度
    var backgroundColor1: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    var defaultTime: CGFloat = 0.5
    
    //初始化视图
    func initPopBackGroundView() -> UIView {
        self.frame = CGRect(x: 0, y: 0, width: screenW, height: screenH)
        self.backgroundColor = backgroundColor1
        self.isHidden = true
        //设置添加地址的View
        self.WhiteView.frame = whiteViewStartFrame
        WhiteView.backgroundColor = .white
        WhiteView.layer.masksToBounds = true
        WhiteView.layer.cornerRadius = 10
        self.addSubview(WhiteView)
        cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x:screenW/2 - 20, y: WhiteView.frame.maxY + 20, width: 40, height: 40)
        cancelBtn.tag = 1
        cancelBtn.setImage(UIImage(named: "cancel_white"), for: .normal)
        cancelBtn.isHidden = true
        cancelBtn.addTarget(self, action: #selector(tapBtnAndcancelBtnClick), for: .touchUpInside)
        self.addSubview(cancelBtn)
        return self
    }
    //弹出的动画效果
    func addAnimate() {
        
    }
    //收回的动画效果
    @objc func tapBtnAndcancelBtnClick() {
        for view in WhiteView.subviews {
            view.removeFromSuperview()
        }
        UIView.animate(withDuration: TimeInterval(defaultTime), animations: {
            self.cancelBtn.isHidden = true
            self.WhiteView.frame = self.whiteViewStartFrame
            self.cancelBtn.frame.origin.y = self.WhiteView.frame.maxY + 20
        }) { (_) in
            self.isHidden = true
        }
        
    }
}
