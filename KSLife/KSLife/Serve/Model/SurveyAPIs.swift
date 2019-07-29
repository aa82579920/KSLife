//
//  SurveyAPIs.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct SurveyAPIs {
    static let getSurveyList = "/survey/getSurveyList"
    static let getQuestion = "/survey/getQuestion"
    static let getTestSurvey = "/survey/getTestSurvey"
    static let postAnswer = "/survey/postAnswer"
//    static let searchDoctor = "/doctor/searchDoctor"
//    static let getRemainFlower = "/doctor/getRemainLike"
//    static let getDoctorActivity = "/doctor/getDoctorActivity"
    static func postAnswer(sid: Int, answer: String) {
        print(answer)
        SolaSessionManager.solaSession(type: .post, url: SurveyAPIs.postAnswer, parameters: ["sid": "\(sid)", "answer": answer], success: { dict in
            print(dict)
        }, failure: { _ in
            
        })
    }
}
