//
//  AuthService.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import Async

class AuthService: NSObject {
    
    static let shared = AuthService()
    let sessionManager = NetworkManager.shared.sessionManager
    
    enum AuthResult {
        case Success()
        case OfflineError
        case UnexpectedError(error: Error?)
        case InvalidCredentials
    }
    
    func getToken(login: String, password: String, callback:((_ result: AuthResult) -> ())? = nil) {
        let endpoint = AuthEndpoint.auth(login: login, password: password)
        
        sessionManager.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters)
            .responseJSON {(response) in
                if let result = response.result.value as? [String: Any] {
                    if let accessToken = result["access_token"] as? String, let refreshToken = result["refresh_token"] as? String {
                        PreferenceManager.shared.token = accessToken
                        PreferenceManager.shared.refreshToken = refreshToken
                        callback?(AuthResult.Success())
                    } else if let error = result["error_description"] as? String, error == ServerError.bad_credentials.raw() {
                        callback?(AuthResult.InvalidCredentials)
                    } else {
                        callback?(AuthResult.UnexpectedError(error: response.result.error))
                    }
                } else {
                    callback?(AuthResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
}
