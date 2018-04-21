//
//  TicketEndpoint.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/20/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation
import Alamofire

enum TicketEndpoint: BaseEndPoint {
    
    case tickets(userId: Int, page: Int, size: Int)
    case ticket(userId: Int, id: Int)
    
    func provideCallDetails() -> (url: String, method: HTTPMethod, parameters: [String : Any]?) {
        switch self {
        case .tickets(let userId, let page, let size):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("users/")
            url.append(String(userId))
            url.append("/tickets")
            url.append("?page=\(page)&size=\(size)")
            return (url: url, method: .get, parameters: nil)
        case .ticket(let userId, let id):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("users/")
            url.append(String(userId))
            url.append("tickets/\(id)")
            return (url: url, method: .get, parameters: nil)
        }
    }
    
}
