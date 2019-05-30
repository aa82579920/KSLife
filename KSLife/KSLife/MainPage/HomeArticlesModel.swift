//
//  HomeArticlesModel.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/29.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation
struct HomeArticles {
    var data: [HomeArticlesData]
    init() {
        self.data = [HomeArticlesData]()
    }
}
struct HomeArticlesData {
    var id: Int
    var imageUrl: String
    var title: String
    var catalogue: String
    var switchUrl: String
    var createTime: String
    var favor: Int
    
    init() {
        self.id = 0
        self.imageUrl = ""
        self.title = ""
        self.catalogue = ""
        self.switchUrl = ""
        self.createTime = ""
        self.favor = -1
    }
}
