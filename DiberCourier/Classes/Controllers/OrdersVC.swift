//
//  OrdersVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import MBProgressHUD

class OrdersVC: UIViewController {
    
    private var ordersTableVC: OrdersTableVC? = nil
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        LogManager.log.info("Initialization")
        loadData(silent: false)
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Prepare segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ordersTable.rawValue {
            if let ordersTableVC = segue.destination as? OrdersTableVC {
                self.ordersTableVC = ordersTableVC
            }
        }
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        OrderService.shared.getOrders() { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success(let orders):
                self_.setup(orders)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
                break
            case .OfflineError:
                self_.showOfflineErrorAlert()
                break
            }
        }
    }
    
    // MARK: Helpers
    
    private func setup(_ orders: [Order]) {
        DataManager.shared.save(orders: orders)
    }
    
}

