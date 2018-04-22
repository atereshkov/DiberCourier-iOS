//
//  SendMessageVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/22/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol SendMessageDelegate: class {
    func messageSent(vc: SendMessageVC)
}

class SendMessageVC: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    
    public var ticketId: Int?
    weak var delegate: SendMessageDelegate? = nil
    
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
        guard let message = messageTextField.text, !message.isEmpty else { return }
        sendMessage(message: message)
    }
    
    // MARK: Networking
    
    private func sendMessage(message: String) {
        guard let ticketId = self.ticketId else { return }
        let userId = PreferenceManager.shared.userId
        TicketService.shared.sendMessage(userId: userId, ticketId: ticketId, message: message) { [weak self] (result) in
            guard let self_ = self else { return }
            defer {
                SVProgressHUD.dismiss()
            }
            
            switch result {
            case .Success(let ticket):
                // TODO show toast message sent
                self?.messageTextField.text = ""
                self_.delegate?.messageSent(vc: self_)
            case .UnexpectedError(let error):
                self_.showUnexpectedErrorAlert(error: error)
            case .OfflineError:
                self_.showOfflineErrorAlert()
            }
        }
    }
    
}
