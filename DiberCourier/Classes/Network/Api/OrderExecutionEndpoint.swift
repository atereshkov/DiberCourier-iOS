//
//  OrderExecutionEndpoint.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 1/21/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation
import Alamofire

enum OrderExecutionEndpoint: BaseEndPoint {
    
    case startOrder(id: Int, status: OrderExecution)
    
    func provideCallDetails() -> (url: String, method: HTTPMethod, parameters: [String : Any]?) {
        switch self {
        case .startOrder(let id, let status):
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
