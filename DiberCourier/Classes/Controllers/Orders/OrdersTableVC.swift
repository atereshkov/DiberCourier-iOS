//
//  OrdersTableVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit

protocol OrdersTableDelegate: class {
    func didReachLastCell(page: Int)
    func didSelectOrder(order: OrderView)
    func didPullRefresh(totalLoadedOrders: Int)
    
    func hideTopView(hide: Bool)
}

class OrdersTableVC: UITableViewController {
    
    fileprivate var orders = [OrderView]()
    fileprivate var debounceTimer: WeakTimer?
    
    weak var delegate: OrdersTableDelegate?
    
    fileprivate var currentPage = 0
    var totalItems = 0
    
    var lastContentOffset: CGFloat = 0
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.orders.rawValue, for: indexPath) as? OrderCell else {
                fatalError("The dequeued cell is not an instance of OrderCell")
        }
        
        guard indexPath.row >= 0 && indexPath.row < orders.count else { return cell }
        let order = orders[indexPath.row]
        cell.bind(with: order)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row >= 0 && indexPath.row < orders.count else { return }
        let order = orders[indexPath.row]
        delegate?.didSelectOrder(order: order)
    }
    
    // MARK: TableView Scroll
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            delegate?.hideTopView(hide: true)
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            delegate?.hideTopView(hide: false)
        }
    }
    
}

