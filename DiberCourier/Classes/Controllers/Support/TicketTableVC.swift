//
//  TicketTableVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/20/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

protocol TicketTableDelegate: class {
    func didReachLastCell(page: Int)
    func didSelectTicket(ticket: TicketView)
    func didPullRefresh(totalLoadedTickets: Int)
}

class TicketTableVC: UITableViewController {
    
    fileprivate var tickets = [TicketView]()
    fileprivate var debounceTimer: WeakTimer?
    
    weak var delegate: TicketTableDelegate?
    
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
    
    func addTickets(_ tickets: [TicketView]) {
        self.tickets.append(contentsOf: tickets)
        reloadOrdersDebounced()
    }
    
    func removeAll() {
        self.currentPage = 0
        self.tickets.removeAll()
    }
    
    // MARK: Private
    
    private func setupRefreshControl() {
        refreshControlView.addTarget(self, action: #selector(handlePullRefresh(_:)), for: .valueChanged)
        refreshControlView.tintColor = UIColor.gray
        tableView.addSubview(refreshControlView)
    }
    
    @objc private func handlePullRefresh(_ refreshControl: UIRefreshControl) {
        delegate?.didPullRefresh(totalLoadedTickets: tickets.count)
        refreshControl.endRefreshing()
    }
    
    fileprivate func reloadOrdersDebounced() {
        debounceTimer?.invalidate()
        debounceTimer = WeakTimer(timeInterval: 0.05, target: self, selector: #selector(reloadTickets), repeats: false)
    }
    
    @objc fileprivate func reloadTickets() {
        self.tableView.reloadData()
    }
    
    private func fetchNextPage() {
        self.currentPage += 1
        self.delegate?.didReachLastCell(page: currentPage)
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ticket.rawValue, for: indexPath) as? TicketCell else {
            fatalError("The dequeued cell is not an instance of TicketCell")
        }
        
        guard indexPath.row >= 0 && indexPath.row < tickets.count else { return cell }
        let ticket = tickets[indexPath.row]
        cell.bind(with: ticket)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row >= 0 && indexPath.row < tickets.count else { return }
        let ticket = tickets[indexPath.row]
        delegate?.didSelectTicket(ticket: ticket)
    }
    
    // MARK: TableView Scroll
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.dataLoading = false
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Uncomment if you wanna have to hide Top View when scrolling
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            //delegate?.hideTopView(hide: true)
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            //delegate?.hideTopView(hide: false)
        }
    }
    
    // Pagination handling
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffset = tableView.contentOffset.y + tableView.frame.size.height
        if (contentOffset + CGFloat(Pagination.cellOffset) >= tableView.contentSize.height) {
            if !dataLoading && self.totalItems > tickets.count {
                self.dataLoading = true
                fetchNextPage()
            }
        }
    }
    
}
