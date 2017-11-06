//
//  Role.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import RealmSwift

class Role: RealmObject {
    
    @objc private(set) dynamic var uuid = UUID().uuidString
    @objc private(set) dynamic var name: String = ""
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
}

// MARK: Serialization

extension Role {
    
    class func with(data: [String: Any]) -> Role? {
        guard let name = data["name"] as? String else {
            LogManager.log.error("Failed to parse Role")
            return nil
        }
        return Role(name: name)
    }
}
