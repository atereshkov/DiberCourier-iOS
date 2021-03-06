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
    case createTicket(userId: Int, ticket: NewTicketDTO)
    case messages(ticketId: Int)
    case sendMessage(userId: Int, ticketId: Int, message: String)
    
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
            url.append("/tickets/\(id)")
            return (url: url, method: .get, parameters: nil)
        case .createTicket(let userId, let ticket):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("users/")
            url.append(String(userId))
            url.append("/tickets")
            let ticketJSON = ticket.toJSON()
            return (url: url, method: .post, parameters: ticketJSON)
        case .messages(let ticketId):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("tickets/")
            url.append(String(ticketId))
            url.append("/messages")
            return (url: url, method: .post, parameters: nil)
        case .sendMessage(let userId, let ticketId, let message):
            var url = "\(Endpoint.base.rawValue)\(Endpoint.apiVersion.rawValue)"
            url.append("users/")
            url.append(String(userId))
            url.append("/tickets/")
            url.append(String(ticketId))
            url.append("/messages")
            let messageJSON = [
                "msg": message
            ]
            return (url: url, method: .post, parameters: messageJSON)
        }
    }
    
}
