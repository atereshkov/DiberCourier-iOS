//
//  OrdersTableVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import RealmSwift

class OrdersTableVC: UITableViewController {
    
    fileprivate var ordersDBO: Results<Order> = DataManager.shared.getOrders()
    fileprivate var orders = [OrderView]()
    
    fileprivate var ordersChangedNotification: NotificationToken? = nil
    fileprivate var debounceTimer: WeakTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNotifications()
    }
    
    deinit {
        debounceTimer?.invalidate()
        ordersChangedNotification?.invalidate()
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Private
    
    fileprivate func registerNotifications() {
        guard !DataManager.shared.isInWriteTransaction else { return }
        ordersChangedNotification?.invalidate()
        ordersChangedNotification = ordersDBO.observe { [weak self] (changes) in
            guard let _self = self else { return }
            switch changes {
            case .initial:
                _self.reloadOrdersDebounced()
            case .update(_, _, _, _):
                _self.reloadOrdersDebounced()
            case .error(let error):
                LogManager.log.error("Failed to update fetch results: \(error)")
            }
        }
    }
    
    fileprivate func reloadOrdersDebounced() {
        debounceTimer?.invalidate()
        debounceTimer = WeakTimer(timeInterval: 0.05, target: self, selector: #selector(reloadOrders), repeats: false)
    }
    
    @objc fileprivate func reloadOrders() {
        self.orders = OrderView.from(orders: ordersDBO)
        self.tableView.reloadData()
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.orders.rawValue, for: indexPath)
            as? OrderCell else {
                fatalError("The dequeued cell is not an instance of OrderCell")
        }
        
        let order = orders[indexPath.row]
        cell.bind(with: order)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

