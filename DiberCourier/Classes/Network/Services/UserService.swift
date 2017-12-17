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
        case Success(user: User)
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    func getUserInfo(callback:((_ result: UserInfoResult) -> ())? = nil) {
        let endpoint = AuthEndpoint.userInfo
        
        sessionManager.request(endpoint.url)
            .validate()
            .responseJSON {(response) in
                if let result = response.result.value as? [String: Any] {
                    if let user = User.with(data: result) {
                        callback?(UserInfoResult.Success(user: user))
                    } else {
                        callback?(UserInfoResult.UnexpectedError(error: nil))
                    }
                } else {
                    callback?(UserInfoResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
}
