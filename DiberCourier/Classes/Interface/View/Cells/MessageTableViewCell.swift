//
//  MessageTableViewCell.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/22/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var messageContainerView: MessageBubbleView!
    @IBOutlet private weak var messageLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    // MARK: Public
    
    func configure(with message: String, currentUserIsSender: Bool) {
        messageLabel.text = message
        messageContainerView.currentUserIsSender = currentUserIsSender
    }
    
}
