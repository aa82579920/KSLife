//
//  AppDelegate.swift
//  KSLife
//
//  Created by uareagay on 2019/4/22.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

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


}

