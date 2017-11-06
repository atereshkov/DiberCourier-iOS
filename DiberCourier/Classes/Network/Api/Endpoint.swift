//
//  Endpoint.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

enum Endpoint: String {
    
    case base = "https://diber-backend.herokuapp.com/"
    case apiVersion = "api/v1/"
    
    case auth = "oauth/token"
    case userInfo = "users/info"
    
    func url(queryParams: [String: String]? = nil) -> String {
        let authUrl = "\(Endpoint.base.rawValue)\(self.rawValue)"
        let commonUrl = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)\(self.rawValue)"
        var url = self == .auth ? authUrl : commonUrl
        
        if let queryParams = queryParams {
            url += "?"
            var index = 0
            for (key, value) in queryParams {
                if index > 0 {
                    url += "&"
                }
                url += "\(key)=\(value)"
                index += 1
            }
        }
        return url
    }
    
}
