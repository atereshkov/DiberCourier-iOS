//
//  SearchVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/8/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        LogManager.log.info("Deinit")
    }
    
    // MARK: Private
    
    
    
    // MARK: Actions
    
    @IBAction func backDidPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
