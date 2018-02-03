//
//  OrdersVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import MBProgressHUD
import DropDown

class OrdersVC: UIViewController {
    
    @IBOutlet weak var topContainerView: UIView!
    
    private var ordersTableVC: OrdersTableVC? = nil
    private var orderDetailVC: OrderDetailVC? = nil
    fileprivate let dropDown = DropDown()
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    fileprivate var hideTopView = false
    fileprivate var debounceTimer: WeakTimer?
    
    fileprivate var sortType: OrderType = PreferenceManager.shared.sortType
    
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
        }
        
        OrderService.shared.getOrders(page: page, size: size) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                MBProgressHUD.hide(for: self_.view, animated: true)
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
    
    private func filterByOrderType(_ orders: [OrderView], type: OrderType) -> [OrderView] {
        let userId = PreferenceManager.shared.userId
        switch type {
        case .all:
            return orders.filter({ $0.status != "Completed" }) // todo get from the server
        case .in_progress:
            return orders.filter({ $0.courier?.id == userId && $0.status == "In progress" })
        case .my:
            return orders.filter({ $0.courier?.id == userId })
        case .completed:
            return orders.filter({ $0.status == "Completed" })
        }
    }
    
    private func setup(_ orders: [OrderDTO], totalElements: Int) {
        guard let ordersTableVC = self.ordersTableVC else { return }
        ordersTableVC.totalItems = totalElements
        let ordersDVO = OrderView.from(orders: orders)
        let filteredOrders = self.filterByOrderType(ordersDVO, type: self.sortType)
        ordersTableVC.addOrders(filteredOrders)
    }
    
    fileprivate func handleOrdersTypeSorting(with type: OrderType) {
        guard let ordersTableVC = ordersTableVC else { return }
        ordersTableVC.removeAll()
        PreferenceManager.shared.sortType = type
        self.sortType = type
        loadData(silent: false)
    }
    
    // MARK: Scrolling
    
    /*
    fileprivate func updateTopViewDebounced() {
        let interval = 0.03
        debounceTimer?.invalidate()
        debounceTimer = WeakTimer(timeInterval: interval, target: self, selector: #selector(updateTopViewState), repeats: false)
    }
    
    @objc fileprivate func updateTopViewState() {
        tableViewContainerDropdown.priority = hideTopView ? UILayoutPriority(rawValue: 250) : UILayoutPriority(rawValue: 900)
        tableViewContainerTopSafe.priority = hideTopView ? UILayoutPriority(rawValue: 900) : UILayoutPriority(rawValue: 250)
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    */
    
}

extension OrdersVC: OrdersTableDelegate {
    
    func didReachLastCell(page: Int) {
        self.loadData(silent: false, page: page)
    }
    
    func didSelectOrder(order: OrderView) {
        // TODO: change status to Enum
        switch order.status {
        case "In progress":
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
