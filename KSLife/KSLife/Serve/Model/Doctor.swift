//
//  Doctor.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/31.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct Doctor: Codable {
    let uid, name, nickname: String
    let photo: String
    let sex, age: Int?
    let introduction, level: String
    let workAge: Int
    let hospital: String
    let poster: String
    let province: String
    let status, follow, likeNum: Int
    
    enum CodingKeys: String, CodingKey {
        case uid, name, nickname, photo, sex, age, introduction, level
        case workAge = "work_age"
        case hospital, poster, province
        case status, follow
        case likeNum = "like_num"
    }
}

struct DoctorMsg: Codable {
    let uid, name, nickname: String
    let photo: String
    let sex, age: Int?
    let introduction, level: String
    let workAge: Int
    let hospital: String
    let poster: String
    let province: String
    let provinceName: String
    let status: Int
    let activity: [Activity]?
    let follow, likeNum: Int
    
    enum CodingKeys: String, CodingKey {
        case uid, name, nickname, photo, sex, age, introduction, level
        case workAge = "work_age"
        case hospital, poster, province
        case provinceName = "province_name"
        case status, activity, follow
        case likeNum = "like_num"
    }
}

struct Activity: Codable {
    let id: Int
    let subject, place: String
    let beginTime, endTime: Int
    
    enum CodingKeys: String, CodingKey {
        case id, subject, place
        case beginTime = "begin_time"
        case endTime = "end_time"
    }
}

enum CircleType: String {
    case flower = "flower"
    case contract = "contract"
    case article = "article"
    case survey = "survey"
    case course = "course"
}

struct Circle: Codable {
    let count: Int
    let type: String
    let content: String?
    let single: Int?
}

struct Lecture: Codable {
    let lid: Int
    let title: String
    let url: String
    let price: Int
    let cover: String
    let viewnum, date, recommend, duration: Int
    let played: Int
    let doctor: String
    let soldnum, collectednum: Int
    let contentFile: String
    let contentImage: String
    
    enum CodingKeys: String, CodingKey {
        case lid, title, url, price, cover, viewnum, date, recommend, duration, played, doctor, soldnum, collectednum
        case contentFile = "content_file"
        case contentImage = "content_image"
    }
}

struct LectureDetail: Codable {
    let lid: Int
    let title, brief: String
    let url: String
    let price: Int
    let cover: String
    let label: String
    let viewnum, date, follow, enroll: Int
    let recommend, duration, played: Int
    let status, soldnum, collectednum: Int
    let contentFile: String
    let contentImage: String
    
    enum CodingKeys: String, CodingKey {
        case lid, title, brief, url, price, cover, label, viewnum, date, follow, enroll, recommend, duration, played, status, soldnum, collectednum
        case contentFile = "content_file"
        case contentImage = "content_image"
    }
}
