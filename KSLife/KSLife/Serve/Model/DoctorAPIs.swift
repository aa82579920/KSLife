//
//  DoctorAPIs.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/31.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct DoctorAPIs {
    static let getDoctorList = "/doctor/getDoctorList"
    static let getDoctorDetail = "/doctor/getDoctorDetail"
    static let setDoctorStatus = "/doctor/setDoctorStatus"
    static let searchDoctor = "/doctor/searchDoctor"
    static let getRemainFlower = "/doctor/getRemainLike"
    static let getDoctorActivity = "/doctor/getDoctorActivity"
    static let getCircle = "/doctor/getCircle"
    static let sendLike = "/doctor/sendLike"
    static let follow = "/doctor/follow"
    
    static func getRemainFlower(uid: String = UserInfo.shared.user.uid, success: @escaping (Int) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: DoctorAPIs.getRemainFlower, parameters: ["uid": uid], success: { dict in
            guard let data = dict["data"] as? [String: Any], let likeNum = data["like_num"] as? Int else {
                return
            }
            success(likeNum)
        }, failure: { _ in
            
        })
    }
}
