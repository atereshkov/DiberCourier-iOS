//
//  TicketListVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/20/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit
import SVProgressHUD

class TicketListVC: UIViewController {
    
    private var ticketTableVC: TicketTableVC? = nil
    private var headerVC: OrderListHeaderVC? = nil
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        
        self.loadData(silent: false)
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Prepare segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ticketTableVC = segue.destination as? TicketTableVC {
            ticketTableVC.delegate = self
            self.ticketTableVC = ticketTableVC
        }
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool, page: Int = 0, size: Int = Pagination.pageSize) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            SVProgressHUD.show()
        }
        
        let userId = PreferenceManager.shared.userId
        TicketService.shared.getTickets(userId: userId, page: page, size: size) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let tickets, _, let totalElements):
                LogManager.log.info("Load tickets: \(tickets.count) | page: \(page)")
                self_.setup(tickets, totalElements: totalElements)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    // MARK: Helpers
    
    private func setup(_ tickets: [TicketDTO], totalElements: Int) {
        guard let ticketTableVC = self.ticketTableVC else { return }
        ticketTableVC.totalItems = totalElements
        let ticketsDVO = TicketView.from(tickets)
        ticketTableVC.addTickets(ticketsDVO)
    }
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TicketListVC: TicketTableDelegate {
    
    func didReachLastCell(page: Int) {
        self.loadData(silent: false, page: page)
    }
    
    func didSelectTicket(ticket: TicketView) {
        let storyboard = UIStoryboard(name: Storyboards.tickets.rawValue, bundle: nil)
        
        if let ticketVC = storyboard.instantiateViewController(withIdentifier: Controllers.ticketDetails.rawValue) as? TicketVC {
            ticketVC.ticketId = ticket.id
            //ticketVC.delegate = self
            self.navigationController?.pushViewController(ticketVC, animated: true)
        }
    }
    
    func didPullRefresh(totalLoadedTickets: Int) {
        guard let ticketTableVC = self.ticketTableVC else { return }
        ticketTableVC.removeAll()
        self.loadData(silent: false, size: 1000) // TODO pass totalLoadedTickets in case of pagination
    }
    
}
