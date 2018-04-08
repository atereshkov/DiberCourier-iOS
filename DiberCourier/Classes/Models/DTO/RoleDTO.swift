//
//  Role.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/8/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation

class RoleDTO {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
}

// MARK: Serialization

extension RoleDTO {
    
    class func with(_ data: [String: Any]) -> RoleDTO? {
        guard let name = data["name"] as? String else {
            LogManager.log.error("Failed to parse UserDTO")
            return nil
        }
        
        return RoleDTO(name: name)
    }
    
    class func from(_ data: [[String: Any]]) -> [RoleDTO] {
        let roles = data.flatMap({ RoleDTO.with($0) })
        return roles
    }
    
}

