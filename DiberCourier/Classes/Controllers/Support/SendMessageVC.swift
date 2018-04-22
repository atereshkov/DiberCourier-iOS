//
//  SendMessageVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/22/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit
import SVProgressHUD

class SendMessageVC: UIViewController {
    
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
    }
    
    // MARK: Networking
    
    /*
    private func sendMessage(message: String) {
        let userId = PreferenceManager.shared.userId
        TicketService.shared.createTicket(userId: userId, ticket: ticket) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
            }
            
            switch result {
            case .Success(let ticket):
                LogManager.log.debug("Ticket with id \(ticket.id) successfully created")
                self_.dismiss(animated: true, completion: nil)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    */
    
}
