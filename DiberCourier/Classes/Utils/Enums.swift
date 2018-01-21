//
//  Enums.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

enum OrderExecution: String {
    
    case new = "New"
    case in_progress = "In progress"
    case accepted = "Accepted"
    
    func displayName() -> String {
        switch self {
        case .new: return "New"
        case .in_progress: return "In progress"
        case .accepted: return "Completed"
        }
    }
    
    static func allItems() -> [OrderExecution] {
        return [.new, .in_progress, .accepted]
    }
    
}

enum OrderType: String {
    
    case all = "All"
    case my = "My"
    case in_progress = "In progress"
    case completed = "Completed"
    
    func displayName() -> String {
        switch self {
        case .all: return "All"
        case .my: return "My"
        case .in_progress: return "In progress"
        case .completed: return "Completed"
        }
    }
    
    static func allItems() -> [OrderType] {
        return [.all, .my, .in_progress, .completed]
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
    case accepted = "Accepted"
    
    func displayName() -> String {
        switch self {
        case .not_reviewed: return "Not reviewed"
        case .canceled_by_courier: return "Canceled by courier"
        case .canceled_by_customer: return "Canceled by customer"
        case .accepted: return "Accepted"
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
