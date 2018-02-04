//
//  OrderListHeaderVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/4/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

class OrderListHeaderVC: TopHeaderVC {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Public API
    
    func set(title: String) {
        titleLabel.text = title
    }
    
}
