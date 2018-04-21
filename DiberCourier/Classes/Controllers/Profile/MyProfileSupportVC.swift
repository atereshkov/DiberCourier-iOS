//
//  MyProfileSupportVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/21/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

protocol MyProfileSupportDelegate: class {
    func contactButtonPressed(vc: MyProfileSupportVC)
}

class MyProfileSupportVC: UIViewController {
    
    weak var delegate: MyProfileSupportDelegate? = nil
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func contactButtonPressed(_ sender: Any) {
        self.delegate?.contactButtonPressed(vc: self)
    }
    
}

