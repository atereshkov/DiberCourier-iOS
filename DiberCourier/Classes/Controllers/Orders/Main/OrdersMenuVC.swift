//
//  OrderMenuController.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 1/28/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

enum OrdersMenuType: String {
    case all = "All"
    case my = "My"
    case completed = "Completed"
    case in_progress = "In progress"
    
    func searchQuery() -> String {
        let id = PreferenceManager.shared.userId
        switch self {
        case .all: return "status!In progress, status!Completed"
        case .my: return "courier.id:\(id)"
        case .completed: return "status:Completed"
        case .in_progress: return "status:In progress,courier.id:\(id)"
        }
    }
}

protocol OrdersMenuDelegate: class {
    func menuPressed(vc: OrdersMenuVC, type: OrdersMenuType)
}

class OrdersMenuVC: UIViewController {

    weak var delegate: OrdersMenuDelegate? = nil
    
    // MARK: Actions
    
    @IBAction func didPressedAll(_ sender: Any) {
        self.delegate?.menuPressed(vc: self, type: OrdersMenuType.all)
    }
    
    @IBAction func didPressedMy(_ sender: Any) {
        self.delegate?.menuPressed(vc: self, type: OrdersMenuType.my)
    }
    
    @IBAction func didPressedInProgress(_ sender: Any) {
        self.delegate?.menuPressed(vc: self, type: OrdersMenuType.in_progress)
    }
    
    @IBAction func didPressedCompleted(_ sender: Any) {
        self.delegate?.menuPressed(vc: self, type: OrdersMenuType.completed)
    }
    
}
