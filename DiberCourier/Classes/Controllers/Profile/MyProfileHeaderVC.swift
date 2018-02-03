//
//  MyProfileHeaderVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/4/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

protocol MyProfileHeaderDelegate: class {
    func signOutButtonPressed(vc: MyProfileHeaderVC)
}

class MyProfileHeaderVC: UIViewController {
    
    weak var delegate: MyProfileHeaderDelegate? = nil
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        self.delegate?.signOutButtonPressed(vc: self)
    }
    
}
