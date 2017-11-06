//
//  PreferenceManager.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

fileprivate enum PreferenceKeys: String {
    case firstRun = "key.diber.firstRun"
    case accessToken = "key.diber.AccessTokenKey"
    case refreshToken = "key.diber.RefreshTokenKey"
    case userId = "key.diber.UserIdKeyPreference"
    case userName = "key.diber.UserNameKeyPreference"
}

class PreferenceManager: NSObject {
    
    static let shared = PreferenceManager()
    
    // MARK: Init
    
    func initialize() {
        LogManager.log.info("Initialize")
        if isFirstRunApp() {
            LogManager.log.info("First run")
            clear()
        }
    }
    
    var token: String {
        get {
            return UserDefaults.standard.string(forKey: PreferenceKeys.accessToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PreferenceKeys.accessToken.rawValue)
        }
    }
    
    var refreshToken: String {
        get {
            return UserDefaults.standard.string(forKey: PreferenceKeys.refreshToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PreferenceKeys.refreshToken.rawValue)
        }
    }
    
    var userId: Int {
        get {
            return UserDefaults.standard.integer(forKey: PreferenceKeys.userId.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PreferenceKeys.userId.rawValue)
        }
    }
    
    var name: String {
        get {
            return UserDefaults.standard.string(forKey: PreferenceKeys.userName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: PreferenceKeys.userName.rawValue)
        }
    }
    
    // MARK: Clear
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: PreferenceKeys.accessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: PreferenceKeys.refreshToken.rawValue)
        UserDefaults.standard.removeObject(forKey: PreferenceKeys.userId.rawValue)
        UserDefaults.standard.removeObject(forKey: PreferenceKeys.userName.rawValue)
    }
    
    func isFirstRunApp() -> Bool {
        return UserDefaults.standard.string(forKey: PreferenceKeys.firstRun.rawValue) == nil
    }
    
    func isAuthorized() -> Bool {
        return !token.isEmpty
    }
    
}
