//
//  TopHeaderVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/3/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

protocol TopHeaderVCDelegate: class {
    func backButtonPressed(vc: TopHeaderVC)
}

class TopHeaderVC: UIViewController {
    
    weak var delegate: TopHeaderVCDelegate? = nil
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.delegate?.backButtonPressed(vc: self)
    }
    
}
