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
    
    @IBOutlet weak var messageTextView: UITextView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.log.info("Initialization")
        
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        messageTextView.layer.cornerRadius = 6
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
    }
    
    // MARK: Networking
    
    private func createTicket(ticket: TicketDTO) {
        /*
        SVProgressHUD.show()
        
        let userId = PreferenceManager.shared.userId
        TicketService.shared.createTicket(userId: userId, ticket: ticket) { [weak self] (result) in
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
        */
    }
    
}
