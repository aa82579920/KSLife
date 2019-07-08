//
//  FoodManager.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/4.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation
class FoodManager {
    static let shared = FoodManager()
    private init() {}
    
    func submitDiet(uid: String, kgId: String, amount: String, unit: String, date: String = Date().toISO([.withFullDate]), type: Int = 1, success: @escaping () -> Void, failure: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.submitDiet, parameters: ["uid": uid, "kgId": kgId, "amount": amount, "unit": unit, "type": "\(type)"], success: { dict in
            guard let status = dict["status"] as? Int else {
                return
            }
            if status == 200 {
                guard let data = dict["data"] as? [String: Any], let score = data["score"] as? String, let dietId = data["dietId"] as? String else {
                    return
                }
                PunchViewController.dietIds.append(dietId)
                success()
            } else {
                failure(dict["msg"] as! String)
            }
        }, failure: { error in
            failure(error.localizedDescription)
        })
    }
    
    func udpateDiet(id: String, amount: String = "", operation: Int = 100, type: Int = 1) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.udpateDiet, parameters: ["id": id, "amount": amount, "operation": "\(operation)", "type": "\(type)"], success: { _ in
            print("成功")
        }, failure: { _ in
            
        })
    }
}
