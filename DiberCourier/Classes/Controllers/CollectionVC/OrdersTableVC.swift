//
//  OrdersTableVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit
import RealmSwift

protocol OrdersTableDelegate: class {
    func didReachLastCell(page: Int)
    func didSelectOrder(order: OrderView)
    func didPullRefresh(totalLoadedOrders: Int)
}

class OrdersTableVC: UITableViewController {
    
    fileprivate var orders = [OrderView]()
    fileprivate var debounceTimer: WeakTimer?
    
    weak var delegate: OrdersTableDelegate?
    
    fileprivate var currentPage = 0
    fileprivate var realmPage = 1
    var totalItems = 0
    var shouldShowLoadingCell = false
    
    private let refreshControlView = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
    }
    
    deinit {
        debounceTimer?.invalidate()
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Public
    
    func addOrders(_ orders: [OrderView]) {
        self.orders.append(contentsOf: orders)
        reloadOrdersDebounced()
    }
    
    func removeAll() {
        self.orders.removeAll()
    }
    
    // MARK: Private
    
    private func setupRefreshControl() {
        refreshControlView.addTarget(self, action: #selector(handlePullRefresh(_:)), for: .valueChanged)
        refreshControlView.tintColor = UIColor.gray
        tableView.addSubview(refreshControlView)
    }
    
    @objc private func handlePullRefresh(_ refreshControl: UIRefreshControl) {
        delegate?.didPullRefresh(totalLoadedOrders: orders.count)
        refreshControl.endRefreshing()
    }
    
    fileprivate func reloadOrdersDebounced() {
        debounceTimer?.invalidate()
        debounceTimer = WeakTimer(timeInterval: 0.05, target: self, selector: #selector(reloadOrders), repeats: false)
    }
    
    @objc fileprivate func reloadOrders() {
        self.tableView.reloadData()
    }
    
    private func fetchNextPage() {
        self.currentPage += 1
        self.realmPage += 1
        self.delegate?.didReachLastCell(page: currentPage)
    }
    
    // MARK: TableView
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == self.orders.count - 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch new data if user scroll to the last cell
        guard isLoadingIndexPath(indexPath) else { return }
        if self.totalItems > orders.count {
            fetchNextPage()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.orders.rawValue, for: indexPath)
            as? OrderCell else {
                fatalError("The dequeued cell is not an instance of OrderCell")
        }
        
        /*
        if isLoadingIndexPath(indexPath) {
            return cell
            //return LoadingCell(style: .default, reuseIdentifier: "LoadingCell")
        } else {
            guard indexPath.row >= 0 && indexPath.row < orders.count else { return cell }
            let order = orders[indexPath.row]
            cell.bind(with: order)
            return cell
        }
        */
        
        guard indexPath.row >= 0 && indexPath.row < orders.count else { return cell }
        let order = orders[indexPath.row]
        cell.bind(with: order)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowLoadingCell ? orders.count + 1 : orders.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row >= 0 && indexPath.row < orders.count else { return }
        let order = orders[indexPath.row]
        delegate?.didSelectOrder(order: order)
    }
    
}

