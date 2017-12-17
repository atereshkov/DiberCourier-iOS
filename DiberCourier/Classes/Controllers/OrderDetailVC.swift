//
//  OrderDetailVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import MBProgressHUD
import Localize_Swift

class OrderDetailVC: UIViewController {
    
    @IBOutlet weak var detailsView: OrderDetailView!
    @IBOutlet weak var requestView: OrderRequestView!
    @IBOutlet weak var priceView: OrderPriceView!
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    var orderId: Int?
    fileprivate(set) var order: OrderView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        guard let id = orderId else { return }
        loadData(silent: false, id: id)
        
        requestView.delegate = self
        detailsView.delegate = self
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
        detailsView.set(order: order)
        priceView.setPrice(order.price)
        requestView.set(order: order)
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool, id: Int) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
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
    
    private func addRequest() {
        guard let id = orderId else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        RequestService.shared.addRequest(orderId: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success():
                self_.showAlert(title: "Request added", message: "Request added succesfully. Don't start order executing until client approval")
                LogManager.log.info("Request added succesfully")
                
                guard let id = self_.orderId else { return }
                self_.loadData(silent: true, id: id)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    private func cancelRequest(id: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        RequestService.shared.cancelRequest(id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
            }
            
            switch result {
            case .Success():
                self_.showAlert(title: "Request canceled", message: "Request was canceled succesfully")
                LogManager.log.info("Request with id \(id) canceled")
                
                guard let id = self_.orderId else { return }
                self_.loadData(silent: true, id: id)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}

extension OrderDetailVC: OrderRequestViewDelegate {
    
    func executeOrderDidPress() {
        let msg = "alert.request.make".localized()
        let cancel = UIAlertAction(title: "alert.cancel".localized(), style: .cancel) { (action) in }
        let ok = UIAlertAction(title: "alert.yes".localized(), style: .default, handler: { (action) in
            self.addRequest()
        })
        
        self.showAlert(with: "alert.request".localized(), and: msg, buttons: [ok, cancel])
    }
    
    func cancelRequestDidPress(from: OrderRequestView, request: RequestView) {
        let msg = "alert.request.cancel".localized()
        let cancel = UIAlertAction(title: "alert.cancel".localized(), style: .cancel) { (action) in }
        let ok = UIAlertAction(title: "alert.yes".localized(), style: .default, handler: { (action) in
            self.cancelRequest(id: request.id)
        })
        
        self.showAlert(with: "alert.request".localized(), and: msg, buttons: [ok, cancel])
    }
    
}

extension OrderDetailVC: OrderDetailViewDelegate {
    
    func showToAddressDetails() {
        // TODO show popup
    }
    
    func showFromAddreesDetails() {
        // TODO show popup
    }
    
}
