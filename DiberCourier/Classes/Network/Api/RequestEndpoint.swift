//
//  RequestEndpoint.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import Alamofire

enum RequestEndpoint: BaseEndPoint {
    
    case requests(userId: Int)
    case request(id: Int)
    
    func provideCallDetails() -> (url: String, method: HTTPMethod, parameters: [String : Any]?) {
        switch self {
        case .requests(let userId):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("users/")
            url.append(String(userId))
            url.append("/requests")
            return (url: url, method: .get, parameters: nil)
        case .request(let id):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("requests/\(id)")
            return (url: url, method: .get, parameters: nil)
        }
    }
    
}