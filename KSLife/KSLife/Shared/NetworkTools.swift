//
//  NetworkTools.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/31.
//  Copyright © 2019 王春杉. All rights reserved.
//

import Foundation
import Alamofire

enum MethodType {
    case get
    case post
}

let ROOT_URL = "http://kangshilife.com/EGuider"

struct SolaSessionManager {
    
    static func solaSession(type: MethodType = .get, baseURL: String = ROOT_URL, url: String, token: String? = nil, parameters: [String: String]? = nil, success: (([String: Any]) -> Void)? = nil, failure: ((Error) -> Void)? = nil) {
        
        let fullurl = baseURL + url
        let para = parameters ?? [String: String]()
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(fullurl, method: method, parameters: para, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.result.value {
                    if let dict = data as? [String: Any] {
                        success?(dict)
                        return
                    }
                }
                let error = response.error ?? CustomError.errorCode(-2, "数据解析错误")
                failure?(error)
            case .failure(let error):
                Alamofire.request(fullurl, method: method, parameters: para, headers: headers).responseString{ response in
                    switch response.result {
                    case .success:
                        if let data = response.result.value {
                            print(data)
                            if let dict = convertToDictionary(text: data) {
                                success?(dict)
                                return
                            }
                        }
                        let error = response.error ?? CustomError.errorCode(-2, "数据解析错误")
                        failure?(error)
                    case .failure( _):
                        return
                    }
                }
                if let data = response.result.value {
                    if let dict = data as? [String: Any],
                        let errmsg = dict["message"] as? String {
                        failure?(CustomError.custom(errmsg))
                        return
                    }
                }
                failure?(error)
            }
        }
    }
    
    static func upload(dictionay: [String: Any], url: String, method: HTTPMethod = .post, progressBlock: ((Progress) -> Void)? = nil, success: (([String: Any]) -> Void)?, failure: ((Error) -> Void)? = nil) {
        
        var dataDict = [String: Data]()
        var paraDict = [String: String]()
        for item in dictionay {
            if let value = item.value as? UIImage {
                let data = UIImage.jpegData(value)(compressionQuality: 1.0)!
                dataDict[item.key] = data
            } else if let value = item.value as? String {
                paraDict[item.key] = value
            }
        }
        
        var headers = HTTPHeaders()
        headers["User-Agent"] = DeviceStatus.userAgent

        let fullURL = ROOT_URL + url
        if method == .post {
            Alamofire.upload(multipartFormData: { formdata in
                for item in dataDict {
                    // TODO: file name
                    formdata.append(item.value, withName: item.key, fileName: "\(item).jpg", mimeType: "image/jpeg")
                }
                for item in paraDict {
                    formdata.append(item.value.data(using: .utf8)!, withName: item.key)
                }
            }, to: fullURL, method: method, headers: headers, encodingCompletion: { response in
                switch response {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (DResponse) in
                        if DResponse.result.isSuccess {
                            if let data = DResponse.result.value {
                                if let dict = data as? [String: Any] {
                                    success?(dict)
                                    return
                                }
                            }
                        } else {
                            return
                        }
                    })
                    upload.uploadProgress { progress in
                        progressBlock?(progress)
                    }
                    break
                case .failure(let error):
                    failure?(error)
                }
            })
            return
        }
        
        if method == .delete {
            Alamofire.request(fullURL, method: .delete, parameters: paraDict, headers: headers).responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let dict = data as? [String: Any], dict["error_code"] as? Int == -1 {
                        success?(dict)
                    } else {
                        
                    }
                case .failure(let error):
                    failure?(error)
                }
            }
            return
        }
    }
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}
