//
//  DangAnProfile.swift
//  KSLife
//
//  Created by 王春杉 on 2019/7/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation
struct DangAnProfile  {
    var mobile: String
    var nickname: String
    var photo: String
    var province_name: String
    var sex: Int
    var age: Int
    var height: Int
    var weight: Int
    var bmi: Int
    var physicalStatus: String
    var demand: String
    
    init() {
        self.mobile = ""
        self.nickname = ""
        self.photo = ""
        self.province_name = ""
        self.sex = 0
        self.age = 0
        self.height = 0
        self.weight = 0
        self.bmi = 0
        self.physicalStatus = ""
        self.demand = ""
    }
}
