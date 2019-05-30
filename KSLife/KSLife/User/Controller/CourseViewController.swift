//
//  CourseViewController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/25.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import WMPageController
class CourseViewController: WMPageController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的消息"
        self.view.backgroundColor = .white
        
        setPageView()
        self.viewControllerClasses = [CourseBuyViewController.self, CourseShouCangViewController.self, CourseStudyViewController.self]
        self.titles = ["已购买(0)", "已收藏(0)", "已学习(0)"]
        self.reloadData()
    }
    
    func setPageView() {
        
        menuItemWidth = Device.width/3   // 每个 MenuItem 的宽度
        menuHeight = 50            // 导航栏高度
        postNotification = true
        bounces = true
        titleSizeSelected = 16    // 选中时的标题尺寸
        titleSizeNormal = 15      // 非选中时的标题尺寸
        menuViewStyle = .line    // Menu view 的样式，默认为无下划线
        titleColorSelected = UIColor.blue    //标题选中时的颜色, 颜色是可动画的.
        titleColorNormal = UIColor.black    //标题非选择时的颜色, 颜色是可动画的
        menuBGColor = UIColor.white        //导航栏背景色
        
    }
}
