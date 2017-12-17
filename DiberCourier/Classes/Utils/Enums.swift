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
    
    func displayName() -> String {
        switch self {
        case .all: return "All"
        case .in_progress: return "In progress"
        }
    }
    
    static func allItems() -> [OrderType] {
        return [.all, .in_progress]
    }
    
    static func selectionItems() -> [String] {
        return allItems().map({ $0.displayName() })
    }
}
