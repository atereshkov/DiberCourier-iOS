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
    
    case orders
    
    func provideCallDetails() -> (url: String, method: HTTPMethod, parameters: [String : Any]?) {
        switch self {
        case .orders:
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("/orders")
            return (url: url, method: .get, parameters: nil)
        }
    }
    
}
