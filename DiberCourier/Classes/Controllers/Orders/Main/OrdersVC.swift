//
//  OrdersVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown

class OrdersVC: UIViewController {
    
    @IBOutlet weak var topContainerView: UIView!
    
    private var ordersTableVC: RecentOrdersTableVC? = nil
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
        if segue.identifier == Segues.recentOrdersTable.rawValue {
            if let ordersTableVC = segue.destination as? RecentOrdersTableVC {
                ordersTableVC.delegate = self
                self.ordersTableVC = ordersTableVC
            }
        } else if segue.identifier == Segues.ordersMainHeader.rawValue {
            if let headerVC = segue.destination as? OrdersMainHeaderVC {
                headerVC.delegate = self
            }
        }
        if let ordersMenuVC = segue.destination as? OrdersMenuVC {
            ordersMenuVC.delegate = self
        }
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool, page: Int = 0, size: Int = Pagination.pageSize) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            SVProgressHUD.show()
        }
        
        let latest = "status!In progress, status!Completed"
        OrderService.shared.getOrders(query: latest, page: page, size: 100) { [weak self] (result) in
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
    
    private func setup(_ orders: [OrderDTO], totalElements: Int) {
        guard let ordersTableVC = self.ordersTableVC else { return }
        ordersTableVC.totalItems = totalElements
        let ordersDVO = OrderView.from(orders: orders)
        ordersTableVC.addOrders(ordersDVO)
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
                orderDetailVC.delegate = self
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

// MARK: OrdersMenuDelegate

extension OrdersVC: OrdersMenuDelegate {
    
    func menuPressed(vc: OrdersMenuVC, type: OrdersMenuType) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Orders", bundle: nil)
        guard let orderListVC = storyBoard.instantiateViewController(withIdentifier: "OrderListVC") as? OrderListVC else { return }
        orderListVC.type = type
        self.navigationController?.pushViewController(orderListVC, animated: true)
    }
    
}

// MARK: OrderDetailVCDelegate

extension OrdersVC: OrderDetailVCDelegate {
    
    func shouldPresentExecutionVC(from vc: OrderDetailVC, orderId: Int) {
        // Pop previous VC
        self.navigationController?.popViewController(animated: false)
        
        // Show OrderExecutionVC
        let storyboard = UIStoryboard(name: Storyboards.orderExecution.rawValue, bundle: nil)
        if let navVC = storyboard.instantiateInitialViewController() as? UINavigationController,
            let orderExecutionVC = navVC.rootViewController as? OrderExecutionVC {
            orderExecutionVC.orderId = orderId
            self.navigationController?.pushViewController(orderExecutionVC, animated: true)
        }
    }
    
}

// MARK: OrdersMainHeaderVCDelegate

extension OrdersVC: OrdersMainHeaderVCDelegate {
    
    func mapButtonPressed(vc: OrdersMainHeaderVC) {
        let storyboard = UIStoryboard(name: Storyboards.map.rawValue, bundle: nil)
        if let navVC = storyboard.instantiateInitialViewController() as? UINavigationController,
            let mapVC = navVC.rootViewController as? MapViewController {
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    func searchButtonPressed(vc: OrdersMainHeaderVC) {
        let storyboard = UIStoryboard(name: Storyboards.search.rawValue, bundle: nil)
        if let navVC = storyboard.instantiateInitialViewController() as? UINavigationController,
            let searchVC = navVC.rootViewController as? SearchVC {
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
}
