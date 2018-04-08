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
    var roles: [RoleDTO] = []
    
    var isCustomer: Bool {
        return roles.contains(where: { $0.name == "ROLE_CUSTOMER" })
    }
    var isCourier: Bool {
        return roles.contains(where: { $0.name == "ROLE_COURIER" })
    }
    
    init(id: Int, email: String, username: String, enabled: Bool, fullname: String, roles: [RoleDTO] = []) {
        self.id = id
        self.email = email
        self.username = username
        self.enabled = enabled
        self.fullname = fullname
        self.roles = roles
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
        
        var roles: [RoleDTO] = []
        if let rolesData = data["roles"] as? [[String:Any]] {
            roles = RoleDTO.from(rolesData)
        }
        
        return UserDTO(id: id, email: email, username: username, enabled: enabled, fullname: fullname, roles: roles)
    }
}
