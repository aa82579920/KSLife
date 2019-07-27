//
//  Survey.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct Survey: Codable {
    let sid: Int
    let title: String
    let createTime, join: Int
    
    enum CodingKeys: String, CodingKey {
        case sid, title
        case createTime = "create_time"
        case join
    }
}

struct Question: Codable {
    let qid: Int
    let question: String
    let type: Int
    let optionList: [String]
}

struct SimpleQuestion: Codable {
    let qid: Int
    let question: String
    let type: Int
}

struct SurveyAnswer: Codable {
    let qid: String
    let options: Int?
    let type: Int
    let answer: String?
}
