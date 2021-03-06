//
//  AppDelegate.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/5/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var shared: AppDelegate {
        get {
            return UIKit.UIApplication.shared.delegate as! AppDelegate
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Setup EXPLogger
        LogManager.shared.initialize()
        
        // Realm
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1)
        LogManager.log.info("[Realm] URL: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        
        // Google Maps & Places
        GMSServices.provideAPIKey("AIzaSyBjw6_8ORK7CM8heg9egK9P824KlbPDiTg")
        
        var initialStoryboard: String? = nil
        if PreferenceManager.shared.isAuthorized() {
            initialStoryboard = "Main"
        } else {
            initialStoryboard = "Login"
        }
        guard let resultStoryboard = initialStoryboard else { return true }
        let storyboard = UIStoryboard(name: resultStoryboard, bundle: nil)
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
        
        UIApplication.shared.statusBarStyle = .lightContent
        // TabBar title adjustment
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        
        // SVProgressHUD Customizing
        customizeSVProgressHUD()
        
        return true
    }
    
    fileprivate func customizeSVProgressHUD() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setBackgroundColor(.clear)
        let progressColor = UIColor(red:0, green:0.68, blue:0.94, alpha:1)
        SVProgressHUD.setForegroundColor(progressColor)
        
        if let view = self.window {
            SVProgressHUD.setContainerView(view)
        }
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

