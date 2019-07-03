//
//  CourseData.swift
//  KSLife
//
//  Created by 王春杉 on 2019/7/2.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
struct CourseData {
    var enroll: [Enroll]
    var learn: [Learn]
    var follow: [Follow]
    init() {
        self.enroll = [Enroll]()
        self.learn = [Learn]()
        self.follow = [Follow]()
    }
}
struct Learn {
    var lid:Int!
    var title: String!
    var url: String!
    var price: Int!
    var cover: String!
    var viewnum: Int!
    var duration: Int!
    var played: Int!
    var doctor: String!
    var content_file: String!
    var content_image: String!
    
    init() {
        self.lid = 0
        self.title = ""
        self.url = ""
        self.price = 0
        self.cover = ""
        self.viewnum = 0
        self.duration = 0
        self.played = 0
        self.doctor = ""
        self.content_file = ""
        self.content_image = ""
    }
}
struct Enroll {
    var lid:Int!
    var title: String!
    var url: String!
    var price: Int!
    var cover: String!
    var viewnum: Int!
    var duration: Int!
    var played: Int!
    var doctor: String!
    var content_file: String!
    var content_image: String!
    
    init() {
        self.lid = 0
        self.title = ""
        self.url = ""
        self.price = 0
        self.cover = ""
        self.viewnum = 0
        self.duration = 0
        self.played = 0
        self.doctor = ""
        self.content_file = ""
        self.content_image = ""
    }
}
struct Follow {
    var lid:Int!
    var title: String!
    var url: String!
    var price: Int!
    var cover: String!
    var viewnum: Int!
    var duration: Int!
    var played: Int!
    var doctor: String!
    var content_file: String!
    var content_image: String!
    
    init() {
        self.lid = 0
        self.title = ""
        self.url = ""
        self.price = 0
        self.cover = ""
        self.viewnum = 0
        self.duration = 0
        self.played = 0
        self.doctor = ""
        self.content_file = ""
        self.content_image = ""
    }
}
