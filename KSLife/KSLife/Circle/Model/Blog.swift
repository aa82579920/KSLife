//
//  Blog.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct Blog: Codable {
    let id: Int
    let content: String
    let cityName: String?
    let userInfo: BlogUserInfo
    let images: [String?]
    let time: String
    let comments: [Comment]?
    let favor, score: Int
    let related: Bool
}

// MARK: - UserInfo
struct BlogUserInfo: Codable {
    let uid: String
    let nickname: String
    let photo: String
    let province: String
    let selfIntro: String?
    let role, status: Int
    
    enum CodingKeys: String, CodingKey {
        case uid, nickname, photo, province
        case selfIntro = "self_intro"
        case role, status
    }
}

struct Comment: Codable {
    let uid, name: String
    let photo: String
    let content, time: String
}
