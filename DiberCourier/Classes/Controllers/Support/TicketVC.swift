//
//  TicketVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/20/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit
import SVProgressHUD

class TicketVC: UIViewController {
    
    
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    var ticketId: Int?
    fileprivate(set) var ticket: TicketView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        guard let ticketId = ticketId else { return }
        loadData(silent: false, id: ticketId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    
    
    // MARK: Helpers
    
    private func setup(_ ticket: TicketDTO) {
        let ticketView = TicketView.create(from: ticket)
        self.ticket = ticketView
        
        guard let ticket = self.ticket else { return }
        //
    }
    
    // MARK: Networking
    
    private func loadData(silent: Bool, id: Int) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            SVProgressHUD.show()
        }
        
        let userId = PreferenceManager.shared.userId
        TicketService.shared.getTicket(userId: userId, id: id) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let ticket):
                self_.setup(ticket)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}
