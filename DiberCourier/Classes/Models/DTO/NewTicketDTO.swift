//
//  NewTicketDTO.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/21/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation

class NewTicketDTO {
    
    private(set) var title: String = ""
    private(set) var message: String = ""
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
}

// MARK: Serialization

extension NewTicketDTO {
    
    func toJSON() -> [String: Any] {
        let json = [
            "title": self.title,
            "message": self.message
        ]
        return json
    }
}
