//
//  RequestCell.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit

protocol RequestCellDelegate : class {
    
}

class RequestCell: UITableViewCell {
    
    @IBOutlet weak var requestIdLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    weak var delegate: RequestCellDelegate?
    
    //MARK:- Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK:- Public
    
    public func bind(with item: RequestView) {
        requestIdLabel.text = "Request #\(item.id)"
        orderIdLabel.text = "Order #\(item.order.id)"
        dateLabel.text = item.date.toString()
        statusLabel.text = item.status.displayName()
    }
    
    //MARK:- Actions
    
    
}
