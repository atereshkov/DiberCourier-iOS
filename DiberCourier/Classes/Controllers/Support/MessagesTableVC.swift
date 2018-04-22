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
        
        tableView.register(UINib(nibName: "MessageTableViewCellReciever", bundle: nil), forCellReuseIdentifier: Cells.ticketMessagesSender.rawValue)
        tableView.register(UINib(nibName: "MessageTableViewCellSender", bundle: nil), forCellReuseIdentifier: Cells.ticketMessagesReciever.rawValue)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        LogManager.log.info("Deinitialization")
    }
    
    // MARK: Public
    
    public func setMessages(_ messages: [MessageView]) {
        self.messages = messages
        tableView.reloadData()
        scrollMessagesToBottom()
    }
    
    public func scrollMessagesToBottom() {
        if messages.count > 0 {
            tableView.scrollToRow(at: IndexPath(item: messages.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    // MARK: TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let currentUserIsSender = message.user.id == PreferenceManager.shared.userId
        
        if currentUserIsSender {
            if let senderCell = tableView.dequeueReusableCell(withIdentifier: Cells.ticketMessagesSender.rawValue) as? MessageTableViewCell {
                let text = message.message
                senderCell.configure(with: text, currentUserIsSender: currentUserIsSender)
                return senderCell
            }
        } else {
            if let recieverCell = tableView.dequeueReusableCell(withIdentifier: Cells.ticketMessagesReciever.rawValue) as? MessageTableViewCell {
                let text = message.message
                recieverCell.configure(with: text, currentUserIsSender: currentUserIsSender)
                return recieverCell
            }
        }
        return UITableViewCell()
    }
}
