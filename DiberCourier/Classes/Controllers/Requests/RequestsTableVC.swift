//
//  RequestsTableVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit

protocol RequestsTableDelegate: class {
    func didReachLastCell(page: Int)
    func didSelectRequest(request: RequestView)
    func didPullRefresh()
}

class RequestsTableVC: UITableViewController {
    
    fileprivate var requests = [RequestView]()
    fileprivate var debounceTimer: WeakTimer?
    
    weak var delegate: RequestsTableDelegate?
    
    fileprivate var currentPage = 0
    var totalItems = 0
    fileprivate var dataLoading = false
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
    
    func addRequests(_ requests: [RequestView]) {
        self.requests.append(contentsOf: requests)
        reloadOrdersDebounced()
    }
    
    func removeAll() {
        self.requests.removeAll()
    }
    
    // MARK: Private
    
    private func setupRefreshControl() {
        refreshControlView.addTarget(self, action: #selector(handlePullRefresh(_:)), for: .valueChanged)
        refreshControlView.tintColor = UIColor.gray
        tableView.addSubview(refreshControlView)
    }
    
    @objc private func handlePullRefresh(_ refreshControl: UIRefreshControl) {
        delegate?.didPullRefresh()
        refreshControl.endRefreshing()
    }
    
    fileprivate func reloadOrdersDebounced() {
        debounceTimer?.invalidate()
        debounceTimer = WeakTimer(timeInterval: 0.05, target: self, selector: #selector(reloadRequests), repeats: false)
    }
    
    @objc fileprivate func reloadRequests() {
        self.tableView.reloadData()
    }
    
    private func fetchNextPage() {
        self.currentPage += 1
        self.delegate?.didReachLastCell(page: currentPage)
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.requests.rawValue, for: indexPath) as? RequestCell else {
            fatalError("The dequeued cell is not an instance of RequestCell")
        }
        
        guard indexPath.row >= 0 && indexPath.row < requests.count else { return cell }
        let request = requests[indexPath.row]
        cell.bind(with: request)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row >= 0 && indexPath.row < requests.count else { return }
        let request = requests[indexPath.row]
        delegate?.didSelectRequest(request: request)
    }
    
    // Pagination handling
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffset = tableView.contentOffset.y + tableView.frame.size.height
        if (contentOffset + CGFloat(Pagination.cellOffset) >= tableView.contentSize.height) {
            if !dataLoading && self.totalItems > requests.count {
                self.dataLoading = true
                fetchNextPage()
            }
        }
    }
    
}
