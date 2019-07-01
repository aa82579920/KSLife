//
//  Message.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct Message: Codable {
    let mid: Int
    let sender, receiver: Receiver
    let content, time: String
    let number: Int
}

// MARK: - Receiver
struct Receiver: Codable {
    let uid: String
    let name: String?
    let nickname: String?
    let photo: String?
    let province: String
    let role, status: Int
    
    enum CodingKeys: String, CodingKey {
        case uid, name, nickname, photo, province, role, status
    }
}
