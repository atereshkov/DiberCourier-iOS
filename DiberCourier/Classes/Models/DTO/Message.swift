//
//  Message.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/21/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation

class MessageDTO {
    
    private(set) var id: Int = -1
    private(set) var message: String = ""
    private(set) var createdDate: Date = Date(timeIntervalSince1970: 1)
    private(set) var updatedDate: Date = Date(timeIntervalSince1970: 1)
    private(set) var user: UserDTO?
    
    init(id: Int, message: String, createdDate: Date, updatedDate: Date, user: UserDTO? = nil) {
        self.id = id
        self.message = message
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.user = user
    }
    
}

// MARK: Serialization

extension MessageDTO {
    
    class func with(data: [String: Any]) -> MessageDTO? {
        guard let id = data["id"] as? Int, let message = data["msg"] as? String, let createdDateInterval = data["created_date"] as? TimeInterval, let updatedDateInterval = data["updated_date"] as? TimeInterval, let userData = data["user"] as? [String: Any], let user = UserDTO.with(data: userData) else {
            LogManager.log.error("Failed to parse Ticket")
            return nil
        }
        let createdDate = Date(timeIntervalSince1970: createdDateInterval)
        let updatedDate = Date(timeIntervalSince1970: updatedDateInterval)
        
        return MessageDTO(id: id, message: message, createdDate: createdDate, updatedDate: updatedDate, user: user)
    }
    
    class func withTest(data: [String: Any]) -> MessageDTO? {
        guard let message = data["message"] as? String else { return nil }
        return MessageDTO(id: 0, message: message, createdDate: Date(timeIntervalSince1970: 1), updatedDate: Date(timeIntervalSince1970: 1), user: nil)
    }
    
}
