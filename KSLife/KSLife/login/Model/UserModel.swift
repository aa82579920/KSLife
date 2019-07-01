//
//  UserModel.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/29.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct User {
    var nickname: String
    var uid: String
    var photo: String
    var sex: Int
    var age: Int
    var height: Int
    var weight: Int
    var role: Int
    var status: Int
    var demand: String
    var physicalStatus: String
    var province_name: String
    var like_num: Int
    
    init() {
        self.nickname = ""
        self.uid = ""
        self.photo = ""
        self.sex = -1
        self.age = -1
        self.height = -1
        self.weight = -1
        self.role = -1
        self.status = -1
        self.demand = ""
        self.physicalStatus = ""
        self.province_name = ""
        self.like_num = -1
    }
}

struct LoginInfo {
    let token = "token"
    let userId = "userId"
}

class UserInfo {
    static let shared = UserInfo()
    private init() {}
    
    var user: User = User()
    var status: Bool = false
    
    func setUserInfo(mobile: String, password: String, success: @escaping () -> Void, failure: @escaping () -> Void) {
        let loginUrl = "http://kangshilife.com/EGuider/user/login"
        Alamofire.request(loginUrl, method: .post, parameters: ["mobile": "13312135091", "password": "aa770119".MD5]).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                //把得到的JSON数据转为数组
                if let value = response.result.value {
                    let json = JSON(value)
                    let status = json["status"].int!
                    if status != 200 {
                        failure()
                    } else {
                        print("--------------\(json["data"]["uid"].string!)")
                        UserInfo.shared.user.uid = json["data"]["uid"].string!
                        UserInfo.shared.user.nickname = json["data"]["nickname"].string!
                        UserInfo.shared.user.photo = json["data"]["photo"].string!
                        UserInfo.shared.user.sex = json["data"]["sex"].int!
                        UserInfo.shared.user.age = json["data"]["age"].int!
                        UserInfo.shared.user.height = json["data"]["height"].int!
                        UserInfo.shared.user.weight = json["data"]["weight"].int!
                        UserInfo.shared.user.role = json["data"]["role"].int!
                        UserInfo.shared.user.status = json["data"]["status"].int!
                        UserInfo.shared.user.demand = json["data"]["demand"].string!
                        UserInfo.shared.user.physicalStatus = json["data"]["physicalStatus"].string!
                        UserInfo.shared.user.province_name = json["data"]["province_name"].string!
                        UserInfo.shared.user.like_num = json["data"]["like_num"].int!
                        success()
                    }
                }
            case false:
                print(response.result.error)
            }
        }
    }
}
