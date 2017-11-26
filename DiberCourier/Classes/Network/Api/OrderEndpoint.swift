//
//  OrderEndpoint.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import Alamofire

enum OrderEndpoint: BaseEndPoint {
    
    case orders(page: Int, size: Int)
    case order(id: Int)
    
    func provideCallDetails() -> (url: String, method: HTTPMethod, parameters: [String : Any]?) {
        switch self {
        case .orders(let page, let size):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("/orders")
            url.append("?page=\(page)&size=\(size)")
            return (url: url, method: .get, parameters: nil)
        case .order(let id):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("/orders/\(id)")
            return (url: url, method: .get, parameters: nil)
        }
    }
    
}
