//
//  TicketCell.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/20/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

protocol TicketCellDelegate : class {
    
}

class TicketCell: UITableViewCell {
    
    
    weak var delegate: TicketCellDelegate?
    
    //MARK:- Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK:- Public
    
    public func bind(with item: TicketView) {
        
    }
    
}
