//
//  AppDelegate.swift
//  HelloFirebase
//
//  Created by 洪德晟 on 2016/10/17.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

// 1. 應用程式啟動時連接 Firebase
import Firebase
// 1. 應用程式啟動時連接 Facebook
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        // 2. 應用程式啟動時連接 Firebase
        FIRApp.configure()
        
        // 2. 應用程式啟動時連接 Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    // 3. 呼叫(Appdelegate既有func) sourceApplication
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return handled
    }
    

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

