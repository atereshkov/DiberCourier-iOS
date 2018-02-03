//
//  MyProfileVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/4/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
    }
    
    // MARK: Prepare segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let headerVC = segue.destination as? MyProfileHeaderVC {
            headerVC.delegate = self
        }
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // Logic
    
    fileprivate func signOut() {
        // TODO SignOut logic
        
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let loginVc = loginStoryboard.instantiateInitialViewController() {
            self.present(loginVc, animated: true, completion: nil)
        }
    }
    
}

extension MyProfileVC: MyProfileHeaderDelegate {
    
    func signOutButtonPressed(vc: MyProfileHeaderVC) {
        self.signOut()
    }
    
}
