//
//  OrderListVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 2/4/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit
import SVProgressHUD
//import DropDown

class OrderListVC: UIViewController {
    
    @IBOutlet weak var topContainerView: UIView!
    
    private var ordersTableVC: OrdersTableVC? = nil
    private var orderDetailVC: OrderDetailVC? = nil
    private var headerVC: OrderListHeaderVC? = nil
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    var type: OrdersMenuType? {
        didSet {
            updateOrdersWithType()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
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
        if let headerVC = segue.destination as? OrderListHeaderVC {
            headerVC.delegate = self
            self.headerVC = headerVC
        }
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool, page: Int = 0, size: Int = Pagination.pageSize) {
        guard let type = type else { return }
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            SVProgressHUD.show()
        }
        
        let query = type.searchQuery()
        OrderService.shared.getOrders(query: query, page: page, size: size) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let orders, _, let totalElements):
                LogManager.log.info("Load orders: \(orders.count) | page: \(page)")
                self_.setup(orders, totalElements: totalElements)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    // MARK: Helpers
    
    private func updateOrdersWithType() {
        guard let type = type else { return }
        loadData(silent: false)
        if let header = headerVC {
            header.set(title: type.rawValue)
        }
    }
    
    private func setup(_ orders: [OrderDTO], totalElements: Int) {
        guard let ordersTableVC = self.ordersTableVC else { return }
        ordersTableVC.totalItems = totalElements
        let ordersDVO = OrderView.from(orders: orders)
        ordersTableVC.addOrders(ordersDVO)
    }
    
}

extension OrderListVC: OrdersTableDelegate {
    
    func didReachLastCell(page: Int) {
        self.loadData(silent: false, page: page)
    }
    
    func didSelectOrder(order: OrderView) {
        // TODO: change status to Enum
        switch order.status {
        case "In progress", "Delivered", "Completed":
            let storyboard = UIStoryboard(name: Storyboards.orderExecution.rawValue, bundle: nil)
            
            if let navVC = storyboard.instantiateInitialViewController() as? UINavigationController,
                let orderExecutionVC = navVC.rootViewController as? OrderExecutionVC {
                orderExecutionVC.orderId = order.id
                //self.present(orderExecutionVC, animated: true, completion: nil)
                self.navigationController?.pushViewController(orderExecutionVC, animated: true)
            }
        default:
            let storyboard = UIStoryboard(name: Storyboards.order.rawValue, bundle: nil)
            
            if let orderNavVC = storyboard.instantiateInitialViewController() as? UINavigationController,
                let orderDetailVC = orderNavVC.rootViewController as? OrderDetailVC {
                orderDetailVC.orderId = order.id
                orderDetailVC.delegate = self
                //self.present(orderNavVC, animated: true, completion: nil)
                self.navigationController?.pushViewController(orderDetailVC, animated: true)
            }
        }
    }
    
    func didPullRefresh(totalLoadedOrders: Int) {
        guard let ordersTableVC = self.ordersTableVC else { return }
        ordersTableVC.removeAll()
        self.loadData(silent: false, size: totalLoadedOrders)
    }
    
}

// MARK: TopHeaderVC Delegate

extension OrderListVC: TopHeaderVCDelegate {
    
    func backButtonPressed(vc: TopHeaderVC) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: OrderDetailVCDelegate

extension OrderListVC: OrderDetailVCDelegate {
    
    func shouldPresentExecutionVC(from vc: OrderDetailVC, orderId: Int) {
        self.navigationController?.popViewController(animated: false)
        let storyboard = UIStoryboard(name: Storyboards.orderExecution.rawValue, bundle: nil)
        
        if let navVC = storyboard.instantiateInitialViewController() as? UINavigationController,
            let orderExecutionVC = navVC.rootViewController as? OrderExecutionVC {
            orderExecutionVC.orderId = orderId
            self.navigationController?.pushViewController(orderExecutionVC, animated: true)
        }
    }
    
}
