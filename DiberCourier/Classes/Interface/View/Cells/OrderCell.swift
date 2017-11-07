//
//  OrderCell.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit

protocol OrderCellDelegate : class {
    
}

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    weak var delegate: OrderCellDelegate?
    
    //MARK:- Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK:- Public
    
    public func bind(with item: OrderView) {
        label.text = "\(item.id) | \(item.date)"
    }
    
    //MARK:- Actions
    
    
}
