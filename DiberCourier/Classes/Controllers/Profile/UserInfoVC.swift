//
//  UserInfoVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/25/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

class UserInfoVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // Public API
    
    func setup(user: UserView) {
        nameLabel.text = user.fullname
        emailLabel.text = user.email
        activeLabel.text = user.enabled ? "Active" : "Disabled"
    }
    
}
