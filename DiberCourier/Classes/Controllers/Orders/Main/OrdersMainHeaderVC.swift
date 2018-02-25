//
//  OrdersMainHeaderVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/25/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

import UIKit

protocol OrdersMainHeaderVCDelegate: class {
    func mapButtonPressed(vc: OrdersMainHeaderVC)
    func searchButtonPressed(vc: OrdersMainHeaderVC)
}

class OrdersMainHeaderVC: UIViewController {
    
    weak var delegate: OrdersMainHeaderVCDelegate? = nil
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func mapButtonPressed(_ sender: Any) {
        self.delegate?.mapButtonPressed(vc: self)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.delegate?.searchButtonPressed(vc: self)
    }
    
}
