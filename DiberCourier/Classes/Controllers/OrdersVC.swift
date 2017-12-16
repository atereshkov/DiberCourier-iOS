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
    private var orderDetailVC: OrderDetailVC? = nil
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                ordersTableVC.delegate = self
                self.ordersTableVC = ordersTableVC
            }
        }
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool, page: Int = 0, size: Int = Pagination.pageSize) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            ordersTableVC?.shouldShowLoadingCell = true
        }
        
        OrderService.shared.getOrders(page: page, size: size) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
                self_.loadingData = false
                self_.ordersTableVC?.shouldShowLoadingCell = false
            }
            
            switch result {
            case .Success(let orders, _, let totalElements):
                LogManager.log.info("Got orders: \(orders.count) | page: \(page)")
                self_.setup(orders, totalElements: totalElements)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    // MARK: Helpers
    
    private func setup(_ orders: [OrderDTO], totalElements: Int) {
        guard let ordersTableVC = self.ordersTableVC else { return }
        ordersTableVC.totalItems = totalElements
        let ordersDVO = OrderView.from(orders: orders)
        ordersTableVC.addOrders(ordersDVO)
    }
    
}

extension OrdersVC: OrdersTableDelegate {
    
    func didReachLastCell(page: Int) {
        self.loadData(silent: false, page: page)
    }
    
    func didSelectOrder(order: OrderView) {
        let storyboard = UIStoryboard(name: Storyboards.order.rawValue, bundle: nil)
        
        if let orderNavVC = storyboard.instantiateInitialViewController() as? UINavigationController,
            let orderDetailVC = orderNavVC.rootViewController as? OrderDetailVC {
            orderDetailVC.orderId = order.id
            self.present(orderNavVC, animated: true, completion: nil)
        }
    }
    
    func didPullRefresh(totalLoadedOrders: Int) {
        guard let ordersTableVC = self.ordersTableVC else { return }
        ordersTableVC.removeAll()
        self.loadData(silent: false, size: totalLoadedOrders)
    }
    
}

