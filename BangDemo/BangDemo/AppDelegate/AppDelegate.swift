//
//  AppDelegate.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/8.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    /** *控制屏幕旋转 */
    var allowRotation = Bool()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        window = UIWindow.init()
        self.window?.frame = UIScreen.main.bounds;
        self.window?.makeKeyAndVisible();
        self.window?.backgroundColor = navColor
        self.window?.rootViewController = MMainViewController()
        
        ///获取uuid
        if (userDefault.object(forKey: "KEY_UUID") == nil) {
            let Udid = getUUID()
            userDefault.set(Udid, forKey: "KEY_UUID")
        }
        
        if userDefault.object(forKey: "USERID") == nil {
            let userID = "2"
            userDefault.set(userID, forKey: "USERID")
        }
        
        ///添加网络监听
        listenNetWorkingStatus()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowRotation {
            return .allButUpsideDown
        }
        return .portrait
    }
    
    func listenNetWorkingStatus() {
        let manager = NetworkReachabilityManager()
        manager?.listener = { status in
            if status == .notReachable {
                MYLog("没有网络")
            }
            if status == .unknown {
                MYLog("未知网络")
            }
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.wwan) {
                MYLog("WWAN网络")
            }
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi) {
                MYLog("WIFI 以太网网络")
            }
            
        }
        manager?.startListening()
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

