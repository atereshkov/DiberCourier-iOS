//
//  UserInfoVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/25/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
}
