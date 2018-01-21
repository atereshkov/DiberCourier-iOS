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
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    weak var delegate: OrderCellDelegate?
    
    //MARK:- Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        icon.image = nil
    }
    
    //MARK:- Public
    
    public func bind(with item: OrderView) {
        fromLabel.text = item.addressFrom.address
        toLabel.text = item.addressTo.address
        descriptionLabel.text = item.descr
        dateTimeLabel.text = item.date.toString()
        
        switch item.status {
        case "In progress":
            icon.image = #imageLiteral(resourceName: "ic_swap")
        case "New":
            icon.image = #imageLiteral(resourceName: "ic_new")
        default:
            icon.image = nil
        }
    }
    
    //MARK:- Actions
    
    
}
