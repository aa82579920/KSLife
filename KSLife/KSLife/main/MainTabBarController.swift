//
//  MainTanBarController.swift
//  KSLife
//
//  Created by uareagay on 2019/4/22.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
struct UserInfo {
    static var user: User = User()
}
class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.isTranslucent = false
        setUserInfo()
        
    }
    func setController() {
        let one = MainPageViewController()
        one.title = "康食"
        let two = UIViewController()
        two.title = "医服务"
        let three = UIViewController()
        three.title = "打卡"
        let four = UIViewController()
        four.title = "食营圈"
        let five = PersonalInfoViewController()
        five.title = "我的"
        self.setViewControllers([UINavigationController(rootViewController: one), UINavigationController(rootViewController: two), UINavigationController(rootViewController: three), UINavigationController(rootViewController: four), UINavigationController(rootViewController: five)], animated: true)
    }
    func setUserInfo() {
        let loginUrl = "http://kangshilife.com/EGuider/user/login?mobile=13312135091&password=2b684baa1a03aaa139d97f02ef398329"
        Alamofire.request(loginUrl, method: .post).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                //把得到的JSON数据转为数组
                if let value = response.result.value {
                    let json = JSON(value)
                    print("--------------\(json["data"]["uid"].string!)")
                    UserInfo.user.uid = json["data"]["uid"].string!
                    UserInfo.user.nickname = json["data"]["nickname"].string!
                    UserInfo.user.photo = json["data"]["photo"].string!
                    UserInfo.user.sex = json["data"]["sex"].int!
                    UserInfo.user.age = json["data"]["age"].int!
                    UserInfo.user.height = json["data"]["height"].int!
                    UserInfo.user.weight = json["data"]["weight"].int!
                    UserInfo.user.role = json["data"]["role"].int!
                    UserInfo.user.status = json["data"]["status"].int!
                    UserInfo.user.demand = json["data"]["demand"].string!
                    UserInfo.user.physicalStatus = json["data"]["physicalStatus"].string!
                    UserInfo.user.province_name = json["data"]["province_name"].string!
                    UserInfo.user.like_num = json["data"]["like_num"].int!
                    
                    self.setController()
                }
            case false:
                print(response.result.error)
            }
        }
    }

}
