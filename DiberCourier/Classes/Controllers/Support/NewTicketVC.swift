//
//  NewTicketVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/21/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewTicketVC: UIViewController {
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        
        setupMessageTextView()
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard let subjectText = subjectTextField.text, !subjectText.isEmpty else { return }
        guard let messageText = messageTextView.text, !messageText.isEmpty else { return }
        let newTicketDTO = NewTicketDTO(title: subjectText, message: messageText)
        createTicket(ticket: newTicketDTO)
    }
    
    // MARK: Networking
    
    private func createTicket(ticket: NewTicketDTO) {
        SVProgressHUD.show()
        
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
    
    private func setupMessageTextView() {
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        messageTextView.layer.cornerRadius = 6
    }
    
}
