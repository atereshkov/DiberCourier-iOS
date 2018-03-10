//
//  User.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 3/10/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation

class UserDTO {
    
    var id: Int
    var email: String
    var username: String
    var enabled: Bool
    var fullname: String
    var customer: Bool
    var courier: Bool
    
    init(id: Int, email: String, username: String, enabled: Bool, fullname: String, customer: Bool, courier: Bool) {
        self.id = id
        self.email = email
        self.username = username
        self.enabled = enabled
        self.fullname = fullname
        self.customer = customer
        self.courier = courier
    }
    
}

// MARK: Serialization

extension UserDTO {
    
    class func with(data: [String: Any]) -> UserDTO? {
        guard let id = data["id"] as? Int, let email = data["email"] as? String, let username = data["username"] as? String, let fullname = data["fullname"] as? String else {
            LogManager.log.error("Failed to parse UserDTO")
            return nil
        }
        
        let enabled = data["enabled"] as? Bool ?? false
        let customer = data["customer"] as? Bool ?? false
        let courier = data["courier"] as? Bool ?? false
        
        return UserDTO(id: id, email: email, username: username, enabled: enabled, fullname: fullname, customer: customer, courier: courier)
    }
}
