//
//  AuthEndpoint.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import Alamofire

enum AuthEndpoint: BaseEndPoint {
    
    case userInfo
    case auth(login: String, password: String)
    
    func provideCallDetails() -> (url: String, method: HTTPMethod, parameters: [String : Any]?) {
        switch self {
        case .auth(let login, let password):
            let params: [String: String] = [
                NetworkConstant.grantType: NetworkConstant.password,
                NetworkConstant.clientId: NetworkConstant.clientIdValue,
                "username": login,
                "password": password
            ]
            return (url: Endpoint.auth.url(), method: .post, parameters: params)
        case .userInfo:
            return (url: Endpoint.userInfo.url(), method: .get, parameters: nil)
        }
    }
    
}
