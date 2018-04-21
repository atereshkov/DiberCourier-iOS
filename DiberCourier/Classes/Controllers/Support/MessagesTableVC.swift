//
//  MessagesTableVC.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/22/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

protocol MessagesTableDelegate: class {
    
}

class MessagesTableVC: UITableViewController {
    
    fileprivate var messages = [MessageView]()
    
    weak var delegate: TicketTableDelegate?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: Cells.ticketMessages.rawValue)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10.0
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Public
    
    public func setMessages(_ messages: [MessageView]) {
        self.messages = messages
        tableView.reloadData()
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.ticketMessages.rawValue) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        let message = messages[indexPath.row]
        let text = message.message
        let currentUserIsSender = message.user.id == PreferenceManager.shared.userId
        cell.configure(with: text, currentUserIsSender: currentUserIsSender)
        return cell
    }
}
