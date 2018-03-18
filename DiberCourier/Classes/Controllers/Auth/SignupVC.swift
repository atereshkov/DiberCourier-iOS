//
//  SignupVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 1/13/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation
import SVProgressHUD

class SignupVC: UIViewController {
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:
    
    private func perfomSignup() {
        
    }
    
}
