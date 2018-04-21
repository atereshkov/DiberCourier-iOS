//
//  Ticket.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/20/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation

class TicketDTO {
    
    private(set) var id: Int = -1
    private(set) var status: String = ""
    private(set) var title: String = ""
    private(set) var createdDate: Date = Date(timeIntervalSince1970: 1)
    private(set) var updatedDate: Date = Date(timeIntervalSince1970: 1)
    private(set) var user: UserDTO?
    
    init(id: Int, status: String, title: String, createdDate: Date, updatedDate: Date, user: UserDTO? = nil) {
        self.id = id
        self.status = status
        self.title = title
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.user = user
    }
    
}

// MARK: Serialization

extension TicketDTO {
    
    class func with(data: [String: Any]) -> TicketDTO? {
        guard let id = data["id"] as? Int, let status = data["status"] as? String, let createdDateInterval = data["created_date"] as? TimeInterval, let updatedDateInterval = data["updated_date"] as? TimeInterval, let title = data["title"] as? String, let userData = data["user"] as? [String: Any], let user = UserDTO.with(data: userData) else {
            LogManager.log.error("Failed to parse Ticket")
            return nil
        }
        let createdDate = Date(timeIntervalSince1970: createdDateInterval)
        let updatedDate = Date(timeIntervalSince1970: updatedDateInterval)
        
        return TicketDTO(id: id, status: status, title: title, createdDate: createdDate, updatedDate: updatedDate, user: user)
    }
    
    class func withTest(data: [String: Any]) -> TicketDTO? {
        guard let title = data["title"] as? String else { return nil }
        return TicketDTO(id: 0, status: "", title: title, createdDate:  Date(timeIntervalSince1970: 1), updatedDate: Date(timeIntervalSince1970: 1), user: nil)
    }
    
}
