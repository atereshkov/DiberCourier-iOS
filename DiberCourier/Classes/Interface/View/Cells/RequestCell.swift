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
    
    @IBOutlet weak var fromLabel: UILabel!
    
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
        fromLabel.text = "\(item.id)"
    }
    
    //MARK:- Actions
    
    
}
