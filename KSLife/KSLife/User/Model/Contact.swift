//
//  contact.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/8.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct Contact: Codable {
    let uid: String
    let name: String?
    let nickname: String?
    let photo: String?
    let selfIntro: String?
    let role: Int
    let remark: String
    let province: String?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case uid, name, nickname, photo, role,  remark, province, status
        case selfIntro = "self_intro"
    }
}
