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

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false
        
        let one = MainPageViewController()
        one.title = "康食"
        one.tabBarItem.image = UIImage(named: "home")
        let two = MedicalServeViewController()
        two.title = "医服务"
        two.tabBarItem.image = UIImage(named: "serve")
        let three = PunchMainViewController()
        three.title = "打卡"
        three.tabBarItem.image = UIImage(named: "punch")
        let four = FoodPreserveViewController()
        four.title = "食营圈"
        four.tabBarItem.image = UIImage(named: "circle")
        let five = PersonalInfoViewController()
        five.title = "我的"
        five.tabBarItem.image = UIImage(named: "my")
        
        self.setViewControllers([UINavigationController(rootViewController: one), UINavigationController(rootViewController: two), UINavigationController(rootViewController: three), UINavigationController(rootViewController: four), UINavigationController(rootViewController: five)], animated: true)
    }
}
