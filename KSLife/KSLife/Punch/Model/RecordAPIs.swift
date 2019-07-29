//
//  RecordAPIs.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

struct RecordAPIs {
    static let getHomeInfo = "/record/getHomeInfo"
    static let getLastRecord = "/record/getLastRecord"
    static let analyseDiet = "/record/analyseDiet"
    static let getUserHistoryRecords = "/record/getUserHistoryRecords"
    static let getRecipeInfo = "/record/getRecipeInfo"
    static let getDishInfo = "/record/getDishInfo"
    static let searchFoods = "/record/searchFoods"
    static let getDietRecord = "/record/getDietRecord"
    static let submitDiet = "/record/submitDiet"
    static let udpateDiet = "/record/udpateDiet"
    static let getRecipeList = "/record/getRecipeList"
    static let searchSetMeals = "/record/searchSetMeals"
    static let submitUserSetMeal = "/record/submitUserSetMeal"
    static let searchRecipes = "/record/searchRecipes"
    
    static func getDishInfo(kgId: String, success: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.getDishInfo, parameters: ["kgId": kgId], success: { dict in
            guard let data = dict["data"] as? [String: Any], let elements = data["elements"] as? String else {
                return
            }
            success(elements)
        }, failure: { _ in
            
        })
    }
    
    static func getRecipeList(uid: String = UserInfo.shared.user.uid, page: Int = 0, type: Int, cateId: String? = nil, success: @escaping ([[SimpleDish]]) -> Void) {
        var parameters = ["uid": uid, "page": "\(page)", "type": "\(type)"]
        if let id = cateId {
            parameters["cateId"] = id
        }
        
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.getRecipeList, parameters: parameters, success: { dict in
            guard let data = dict["data"] as? [String: Any], let recipeList = data["recipeList"] as? [Any], let groups = data["groups"] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: recipeList, options: [])
                let list = try JSONDecoder().decode([SimpleDish].self, from: json)
                let jsonSec = try JSONSerialization.data(withJSONObject: groups, options: [])
                let groups = try JSONDecoder().decode([SimpleDish].self, from: jsonSec)
                success([groups, list])
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
}

struct CheckinAPIs {
    static let applyReport = "/checkin/applyReport"
}
