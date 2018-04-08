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
    case searchOrders(query: String, page: Int, size: Int)
    case order(id: Int)
    case addRequest(orderId: Int)
    case complete(id: Int, status: OrderStatus)
    case cancel(id: Int, status: OrderStatus)
    
    func provideCallDetails() -> (url: String, method: HTTPMethod, parameters: [String : Any]?) {
        switch self {
        case .orders(let page, let size):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("orders")
            url.append("?page=\(page)&size=\(size)")
            return (url: url, method: .get, parameters: nil)
        case .searchOrders(let query, let page, let size):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("orders")
            url.append("?search=\(query)&page=\(page)&size=\(size)")
            let endUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
            return (url: endUrl, method: .get, parameters: nil)
        case .order(let id):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("orders/\(id)")
            return (url: url, method: .get, parameters: nil)
        case .addRequest(let orderId):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("orders/\(orderId)")
            url.append("/requests")
            return (url: url, method: .post, parameters: nil)
        case .complete(let id, let status):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("orders/\(id)")
            url.append("/status")
            
            let params: [String: String] = [
                "status": status.rawValue
            ]
            return (url: url, method: .put, parameters: params)
        case .cancel(let id, let status):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("orders/\(id)")
            url.append("/status")
            
            let params: [String: String] = [
                "status": status.rawValue
            ]
            return (url: url, method: .put, parameters: params)
        }
    }
    
}
