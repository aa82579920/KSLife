//
//  AppDelegate.swift
//  KSLife
//
//  Created by uareagay on 2019/4/22.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?
    let wechatAppID: String = "wx3b6697d048ab15ba"
    let wechatAppSecret: String = "6358ce9c7d23719f8b3f73be2e82a977"
    //当前界面支持的方向（默认情况下只能竖屏，不能横屏显示）
    var interfaceOrientations:UIInterfaceOrientationMask = .portrait{
        didSet{
            //强制设置成竖屏
            if interfaceOrientations == .portrait{
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                          forKey: "orientation")
            }
                //强制设置成横屏
            else if !interfaceOrientations.contains(.portrait){
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue,
                                          forKey: "orientation")
            }
        }
    }
    
    //返回当前界面支持的旋转方向
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor
        window: UIWindow?)-> UIInterfaceOrientationMask {
        return interfaceOrientations
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        WXApi.registerApp(self.wechatAppID)
//        let mainVC = MainTabBarController()
//        self.window?.rootViewController = mainVC
        guard let userId = UserDefaults.standard.value(forKey: LoginInfo().userId) as? String, let pass = UserDefaults.standard.value(forKey: LoginInfo().token) as? String else {
            let mainVC = LoginViewController()
            self.window?.rootViewController = mainVC
            return true
        }
        UserInfo.shared.setUserInfo(mobile: userId, password: pass, success: {
            let mainVC = MainTabBarController()
            self.window?.rootViewController = mainVC
        }, failure: {
            let mainVC = LoginViewController()
            self.window?.rootViewController = mainVC
        })

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // 微信跳转回调
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlKey: String = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String
        
        if urlKey == "com.tencent.xin" {
            // 微信 的回调
            return  WXApi.handleOpen(url, delegate: self)
        }
        
        return true
    }
    
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        // 这里是使用异步的方式来获取的
        let sendRes: SendAuthResp? = resp as? SendAuthResp
        let queue = DispatchQueue(label: "wechatLoginQueue")
        queue.async {
            
            print("async: \(Thread.current)")
            if let sd = sendRes {
                if sd.errCode == 0 {
                    
                    guard (sd.code) != nil else {
                        return
                    }
                    // 第一步: 获取到code, 根据code去请求accessToken
                    self.requestAccessToken((sd.code)!)
                } else {
                    
                    DispatchQueue.main.async {
                        // 授权失败
                        print("118行-授权失败")
                    }
                }
            } else {
                
                DispatchQueue.main.async {
                    // 异常
                    print("125行-异常")
                }
            }
        }
    }
    private func requestAccessToken(_ code: String) {
        // 第二步: 请求accessToken
        let urlStr = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(self.wechatAppID)&secret=\(self.wechatAppSecret)&code=\(code)&grant_type=authorization_code"
        
        let url = URL(string: urlStr)
        
        do {
            //                    let responseStr = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            
            guard dic != nil else {
                DispatchQueue.main.async {
                    // 获取授权信息异常
                    print("获取授权信息异常")
                }
                return
            }
            
            guard dic!["access_token"] != nil else {
                DispatchQueue.main.async {
                    print("获取授权信息异常")
                }
                return
            }
            
            guard dic!["openid"] != nil else {
                DispatchQueue.main.async {
                    // 获取授权信息异常
                    print("获取授权信息异常")
                }
                return
            }
            // 根据获取到的accessToken来请求用户信息
            self.requestUserInfo(dic!["access_token"]! as! String, openID: dic!["openid"]! as! String)
        } catch {
            DispatchQueue.main.async {
                // 获取授权信息异常
                print("168行-获取授权信息异常")
            }
        }
    }
    private func requestUserInfo(_ accessToken: String, openID: String) {
        
        let urlStr = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openID)"
        
        let url = URL(string: urlStr)
        
        do {
            
            let responseData = try Data.init(contentsOf: url!, options: Data.ReadingOptions.alwaysMapped)
            
            let dic = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any>
            
            guard dic != nil else {
                DispatchQueue.main.async {
                    // 获取授权信息异常
                    print("188行-获取授权信息异常")
                }
                
                return
            }
            // 这个字典(dic)内包含了我们所请求回的相关用户信息
            if let dic = dic {
                print("这个字典(dic)内包含了我们所请求回的相关用户信息")
                print(dic)
                var data: [String: Any] = [
                    "unionid": dic["unionid"]!,
                    "openid": dic["openid"]!,
                    "headimgurl": dic["headimgurl"]!,
                    "nickname": dic["nickname"]!,
                    "sex": dic["sex"]!
                ]
                
            }
        } catch {
            DispatchQueue.main.async {
                // 获取授权信息异常
            }
        }
    }
}
