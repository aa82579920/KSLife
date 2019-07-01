//
//  Dish.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct Dish: Codable {
    let id: Int
    let uid, kgID: String
    let type, groupID: Int
    let amount, unit, name: String
    let icon: String
    let updateTime: Int
    let insertDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, uid
        case kgID = "kgId"
        case type
        case groupID = "groupId"
        case amount, unit, name, icon, updateTime, insertDate
    }
}

struct SimpleDish: Codable {
    let kgID, name: String
    let icon: String
//    let type: Int
    
    enum CodingKeys: String, CodingKey {
        case kgID = "kgId"
        case name, icon
    }
}

struct Nutrient: Codable {
    let name, unit, value: String
    let radarValue, referValue: Double
}

struct DishDiet {
    let kgID, amount, unit:String
    let type: Int
}
