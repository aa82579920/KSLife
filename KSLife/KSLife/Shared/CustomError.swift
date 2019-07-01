//
//  CustomError.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/31.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation

enum CustomError: Error {
    case custom(String)
    case errorCode(Int, String)
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .custom(let desc):
            return desc
        case .errorCode(let code, let desc):
            return desc + " 代码: \(code)"
        }
    }
}
