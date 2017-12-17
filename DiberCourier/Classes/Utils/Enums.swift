//
//  Enums.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

enum OrderType: String {
    
    case all = "All"
    case in_progress = "In progress"
    case request_submitted = "Request submitted"
    
    func displayName() -> String {
        switch self {
        case .all: return "All"
        case .in_progress: return "In progress"
        case .request_submitted: return "Request submitted"
        }
    }
    
    static func allItems() -> [OrderType] {
        return [.all, .in_progress, .request_submitted]
    }
    
    static func selectionItems() -> [String] {
        return allItems().map({ $0.displayName() })
    }
}

// TODO
enum RequestStatus: String {
    
    case not_reviewed = "Not reviewed"
    case canceled_by_courier = "Canceled by courier"
    case canceled_by_customer = "Canceled by customer"
    
    func displayName() -> String {
        switch self {
        case .not_reviewed: return "Not reviewed"
        case .canceled_by_courier: return "Canceled by courier"
        case .canceled_by_customer: return "Canceled by customer"
        }
    }
    
}

enum ServerError: String {
    
    case unexpected = "Unexpected error"
    case bad_credentials = "Bad credentials"
    
    func raw() -> String {
        switch self {
        case .unexpected: return self.rawValue
        case .bad_credentials: return self.rawValue
        }
    }
    
}
