//
//  OrderDetailVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import MBProgressHUD

class OrderDetailVC: UIViewController {
    
    @IBOutlet weak var detailsView: OrderDetailView!
    @IBOutlet weak var requestView: OrderRequestView!
    @IBOutlet weak var priceView: OrderPriceView!
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    var orderId: Int?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        guard let id = orderId else { return }
        loadData(silent: false, id: id)
        
        requestView.delegate = self
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func backButtonDidPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    private func setup(_ order: Order) {
        
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool, id: Int) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let size = Pagination.pageSize
        OrderService.shared.getOrder(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
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
    
    private func refreshRequests() {
        
    }
    
}

extension OrderDetailVC: OrderRequestViewDelegate {
    
    func executeOrderDidPress() {
        guard let id = orderId else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        OrderService.shared.addRequest(orderId: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success():
                LogManager.log.info("Request added succesfully")
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}
