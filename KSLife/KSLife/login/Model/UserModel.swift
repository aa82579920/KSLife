//
//  UserModel.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/29.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation
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
