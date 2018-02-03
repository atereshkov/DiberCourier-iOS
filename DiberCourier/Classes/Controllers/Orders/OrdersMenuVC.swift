//
//  OrderMenuController.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 1/28/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

enum OrdersMenuType {
    case all
    case my
    case completed
    case in_progress
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
