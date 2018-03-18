//
//  OrderExecutionVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 1/21/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation
import SVProgressHUD
import Localize_Swift
import PopupDialog

class OrderExecutionVC: UIViewController {
    
    
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    var orderId: Int?
    fileprivate(set) var order: OrderView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        loadData(silent: false)
    }
    
    // MARK: Prepare segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let headerVC = segue.destination as? TopHeaderVC {
            headerVC.delegate = self
        }
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func backButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    private func setup(_ order: OrderDTO) {
        let orderView = OrderView.create(from: order)
        self.order = orderView
        
        guard let order = self.order else { return }
        // TODO bind data
    }
    
}

// MARK: Networking

extension OrderExecutionVC {
    
    fileprivate func loadData(silent: Bool) {
        guard let id = orderId else { return }
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            SVProgressHUD.show()
        }
        
        OrderService.shared.getOrder(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let order):
                self_.setup(order)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}

// MARK: TopHeaderVC Delegate

extension OrderExecutionVC: TopHeaderVCDelegate {
    
    func backButtonPressed(vc: TopHeaderVC) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
