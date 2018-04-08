//
//  UserService.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import Async

class UserService: NSObject {
    
    static let shared = UserService()
    let sessionManager = NetworkManager.shared.sessionManager
    
    enum UserInfoResult {
        case Success(user: UserDTO)
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    func getUserInfo(callback:((_ result: UserInfoResult) -> ())? = nil) {
        let endpoint = AuthEndpoint.userInfo
        
        sessionManager.request(endpoint.url)
            .validate()
            .responseJSON {(response) in
                if let result = response.result.value as? [String: Any] {
                    if let user = UserDTO.with(data: result) {
                        callback?(UserInfoResult.Success(user: user))
                    } else {
                        callback?(UserInfoResult.UnexpectedError(error: nil))
                    }
                } else {
                    callback?(UserInfoResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
    enum UserDataResult {
        case Success(user: UserDTO)
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    func getUserProfileData(callback:((_ result: UserDataResult) -> ())? = nil) {
        let endpoint = AuthEndpoint.userInfo
        
        sessionManager.request(endpoint.url)
            .validate()
            .responseJSON {(response) in
                if let result = response.result.value as? [String: Any] {
                    if let user = UserDTO.with(data: result) {
                        callback?(UserDataResult.Success(user: user))
                    } else {
                        callback?(UserDataResult.UnexpectedError(error: nil))
                    }
                } else {
                    callback?(UserDataResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
}
