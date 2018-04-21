//
//  TicketService.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/20/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation
import Async
import Alamofire

class TicketService: NSObject {
    
    static let shared = TicketService()
    let sessionManager = NetworkManager.shared.sessionManager
    
    enum TicketsResult {
        case Success(tickets: [TicketDTO], totalPages: Int, totalElements: Int)
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    enum TicketResult {
        case Success(ticket: TicketDTO)
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    enum CreateTicketResult {
        case Success(ticket: TicketDTO)
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    func getTickets(userId: Int, page: Int, size: Int, callback:((_ result: TicketsResult) -> ())? = nil) {
        let endpoint = TicketEndpoint.tickets(userId: userId, page: page, size: size)
        
        sessionManager.request(endpoint.url)
            .validate()
            .responseJSON { response in
                var tickets = [TicketDTO]()
                if response.result.error == nil, let data = response.result.value as? [String: Any] {
                    if let ticketsData = data["content"] as? [[String: Any]] {
                        for ticketData in ticketsData {
                            if let ticket = TicketDTO.with(data: ticketData) {
                                tickets.append(ticket)
                            }
                        }
                    }
                    let totalPages = data["totalPages"] as? Int ?? 0
                    let totalElements = data["totalElements"] as? Int ?? 0
                    callback?(TicketsResult.Success(tickets: tickets, totalPages: totalPages, totalElements: totalElements))
                } else {
                    callback?(TicketsResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
    func getTicket(userId: Int, id: Int, callback:((_ result: TicketResult) -> ())? = nil) {
        let endpoint = TicketEndpoint.ticket(userId: userId, id: id)
        
        sessionManager.request(endpoint.url)
            .validate()
            .responseJSON { response in
                if response.result.error == nil, let data = response.result.value as? [String: Any] {
                    if let ticket = TicketDTO.with(data: data) {
                        callback?(TicketResult.Success(ticket: ticket))
                    }
                } else {
                    callback?(TicketResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
    func createTicket(userId: Int, ticket: NewTicketDTO, callback:((_ result: CreateTicketResult) -> ())? = nil) {
        let endpoint = TicketEndpoint.createTicket(userId: userId, ticket: ticket)
        
        sessionManager.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if let data = response.result.value as? [String: Any] {
                    if let error = data["error_description"] as? String {
                        let customError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])
                        callback?(CreateTicketResult.UnexpectedError(error: customError))
                    } else {
                        // TODO change withTest to with
                        if let ticket = TicketDTO.withTest(data: data) {
                            callback?(CreateTicketResult.Success(ticket: ticket))
                        }
                    }
                } else {
                    callback?(CreateTicketResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
}

