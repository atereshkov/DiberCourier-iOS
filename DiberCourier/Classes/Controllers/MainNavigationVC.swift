//
//  MainNavigationVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit

class MainNavigationVC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(authExpiredNotification(notification:)), name: .AuthenticationExpired, object: nil)
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
        NotificationCenter.default.removeObserver(self, name: .AuthenticationExpired, object: nil)
    }
    
    //MARK:- Notifications
    
    @objc internal func authExpiredNotification(notification: Notification) {
        self.performSegue(withIdentifier: Segues.loginFromMain.rawValue, sender: self)
    }
    
}
