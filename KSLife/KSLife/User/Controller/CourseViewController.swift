//
//  CourseViewController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/25.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import WMPageController
import Alamofire
import SwiftyJSON
struct CourseInfo {
    static var courseInfo: CourseData = CourseData()
}
class CourseViewController: WMPageController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "我的课程"
        self.view.backgroundColor = .white
        
        setPageView()
        
        let Url = "http://kangshilife.com/EGuider/doctor/myLecture"
        Alamofire.request(Url, method: .post).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                //把得到的JSON数据转为数组
                if let value = response.result.value {
                    let json = JSON(value)
                    if json["status"].int == 200 {
                        
                        var enrollCounts = json["data"]["enroll"].count
                        for i in 0..<enrollCounts {
                            var newEnroll = Enroll()
                            newEnroll.content_file = json["data"]["enroll"][i]["content_file"].string!
                            newEnroll.content_image = json["data"]["enroll"][i]["content_image"].string!
                            newEnroll.cover = json["data"]["enroll"][i]["cover"].string!
                            newEnroll.doctor = json["data"]["enroll"][i]["doctor"].string!
                            newEnroll.duration = json["data"]["enroll"][i]["duration"].int!
                            newEnroll.lid = json["data"]["enroll"][i]["lid"].int!
                            newEnroll.played = json["data"]["enroll"][i]["played"].int!
                            newEnroll.price = json["data"]["enroll"][i]["price"].int!
                            newEnroll.title = json["data"]["enroll"][i]["title"].string!
                            newEnroll.url = json["data"]["enroll"][i]["url"].string!
                            newEnroll.viewnum = json["data"]["enroll"][i]["viewnum"].int!
                            CourseInfo.courseInfo.enroll.append(newEnroll)
                        }
                    }
                    self.viewControllerClasses = [CourseBuyViewController.self, CourseShouCangViewController.self, CourseStudyViewController.self]
                    self.titles = ["已购买(\(CourseInfo.courseInfo.enroll.count))", "已收藏(0)", "已学习(0)"]
                    self.reloadData()
                }
            case false:
                print(response.result.error)
            }
            
        }
        
        
        
        
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
