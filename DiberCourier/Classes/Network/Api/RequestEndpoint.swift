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
    case requestBy(orderId: Int, courierId: Int)
    case cancel(id: Int, status: RequestStatus)
    
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
        case .requestBy(let orderId, let courierId):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("requests/order/\(orderId)/user/\(courierId)")
            return (url: url, method: .get, parameters: nil)
        case .cancel(let id, let status):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("requests/\(id)")
            url.append("/status")
            
            let params: [String: String] = [
                "status": status.rawValue
            ]
            return (url: url, method: .put, parameters: params)
        }
    }
    
}
