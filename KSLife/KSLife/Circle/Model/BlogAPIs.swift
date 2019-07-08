//
//  BlogAPIs.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct BlogAPIs {
    static let getAllBlogs = "/blog/getAllBlogs"
    static let getBlogs = "/blog/getBlogs"
    static let getBlog = "/blog/getBlog"
    static let getBanner = "/blog/getBanner"
    static let postComment = "/blog/postComment"
    static let getComments = "/blog/getComments"
    static let postBlog = "/blog/postBlog"
    static let upload = "/image/upload"
    
    static func getComments(bid: Int, type: Int = 0, page: Int = 0, success: @escaping ([Comment]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: BlogAPIs.getComments, parameters: ["bid": "\(bid)", "type": "\(type)", "page": "\(page)"], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            var comments = [Comment]()
            for comment in data {
                do {
                    let json = try JSONSerialization.data(withJSONObject: comment, options: [])
                    let com = try JSONDecoder().decode(Comment.self, from: json)
                    comments.append(com)
                } catch {
                    print("cant show comment")
                }
            }
            success(comments)
        }, failure: { error in
            print(error)
        })
    }
    
    static func postComment(bid: Int, uid: String, comment: String, success: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: BlogAPIs.postComment, parameters: ["bid": "\(bid)", "uid": "\(uid)", "comment": comment], success: { dict in
            guard let msg = dict["msg"] as? String else {
                return
            }
            success(msg)
        }, failure: { error in
            print(error)
        })
    }
}
