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
    
    private var messagesTableVC: MessagesTableVC? = nil
    
    @IBOutlet weak var headerLabel: UILabel!
    
    fileprivate var loadingData = false // Used to prevent multiple simultanious load requests
    
    var ticketId: Int?
    fileprivate(set) var ticket: TicketView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        guard let ticketId = ticketId else { return }
        headerLabel.text = "Ticket #\(ticketId)"
        loadTicket(silent: false, id: ticketId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let messagesTableVC = segue.destination as? MessagesTableVC {
            self.messagesTableVC = messagesTableVC
        }
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helpers
    
    private func setup(_ ticket: TicketDTO) {
        let ticketView = TicketView.create(from: ticket)
        self.ticket = ticketView
        
        guard let ticket = self.ticket else { return }
        self.loadMessages(ticketId: ticket.id)
    }
    
    private func load(_ messages: [MessageDTO]) {
        let messages = MessageView.from(messages)
        
        guard let messagesTableVC = self.messagesTableVC else { return }
        messagesTableVC.setMessages(messages)
    }
    
    // MARK: Networking
    
    private func loadTicket(silent: Bool, id: Int) {
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
                self_.loadingData = false
                self_.setup(ticket)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
    private func loadMessages(silent: Bool = false, ticketId: Int) {
        guard !loadingData else { return }
        loadingData = true
        if !silent {
            SVProgressHUD.show()
        }
        
        let userId = PreferenceManager.shared.userId
        TicketService.shared.getMessages(ticketId: ticketId) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
                self_.loadingData = false
            }
            
            switch result {
            case .Success(let messages):
                self_.load(messages)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}
