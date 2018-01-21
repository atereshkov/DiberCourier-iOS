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
    @IBOutlet weak var tableViewContainerTopSafe: NSLayoutConstraint!
    @IBOutlet weak var tableViewContainerDropdown: NSLayoutConstraint!
    
    private var ordersTableVC: OrdersTableVC? = nil
    private var orderDetailVC: OrderDetailVC? = nil
    private var dropDownVC: OrdersDropdownVC? = nil
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
        setupDropDownView()
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
        } else if segue.identifier == Segues.ordersDropDown.rawValue {
            if let dropDownVC = segue.destination as? OrdersDropdownVC {
                dropDownVC.delegate = self
                self.dropDownVC = dropDownVC
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
    
    private func setupDropDownView() {
        dropDown.anchorView = topContainerView
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: topContainerView.bounds.height)
        dropDown.dataSource = OrderType.selectionItems()
        
        dropDown.cancelAction = { [weak self] in
            guard let self_ = self, let dropDownVC = self_.dropDownVC else { return }
            dropDownVC.setState(DropdownState.collapsed)
        }
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self_ = self, let dropDownVC = self_.dropDownVC else { return }
            dropDownVC.setSelected(item)
            dropDownVC.setState(DropdownState.collapsed)
            guard let orderType = OrderType(rawValue: item) else { return }
            self_.handleOrdersTypeSorting(with: orderType)
        }
        
        guard let dropDownVC = self.dropDownVC, OrderType.selectionItems().count > 0 else { return }
        let initialIndex = OrderType.selectionItems().index(of: PreferenceManager.shared.sortType.rawValue)
        dropDownVC.setSelected(PreferenceManager.shared.sortType.rawValue)
        dropDown.selectRow(at: initialIndex)
    }
    
    fileprivate func handleOrdersTypeSorting(with type: OrderType) {
        guard let ordersTableVC = ordersTableVC else { return }
        ordersTableVC.removeAll()
        PreferenceManager.shared.sortType = type
        self.sortType = type
        loadData(silent: false)
    }
    
    // MARK: Scrolling
    
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
    
    func hideTopView(hide: Bool) {
        self.hideTopView = hide
        updateTopViewDebounced()
    }
    
}

extension OrdersVC: OrdersDropdownDelegate {
    
    func stateChanged(controller: OrdersDropdownVC, to state: DropdownState) {
        switch state {
        case .collapsed:
            dropDown.hide()
        case .expanded:
            dropDown.show()
        }
    }
    
}
