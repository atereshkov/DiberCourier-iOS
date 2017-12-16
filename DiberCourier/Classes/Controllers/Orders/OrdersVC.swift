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
    
    private var ordersTableVC: OrdersTableVC? = nil
    private var orderDetailVC: OrderDetailVC? = nil
    private var dropDownVC: OrdersDropdownVC? = nil
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    fileprivate let dropDown = DropDown()
    @IBOutlet weak var topContainerView: UIView!
    
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
    
    private func setupDropDownView() {
        dropDown.anchorView = topContainerView
        dropDown.direction = .bottom
        dropDown.bottomOffset = CGPoint(x: 0, y: topContainerView.bounds.height)
        
        dropDown.cancelAction = { [weak self] in
            guard let self_ = self, let dropDownVC = self_.dropDownVC else { return }
            dropDownVC.setState(DropdownState.collapsed)
        }
        
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self_ = self, let dropDownVC = self_.dropDownVC else { return }
            dropDownVC.setSelected(item)
            dropDownVC.setState(DropdownState.collapsed)
        }
        
        dropDown.dataSource = OrderType.selectionItems()
        
        guard let dropDownVC = self.dropDownVC, OrderType.selectionItems().count > 0 else { return }
        let initialIndex = 0
        dropDownVC.setSelected(OrderType.selectionItems()[initialIndex])
        dropDown.selectRow(at: initialIndex)
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
