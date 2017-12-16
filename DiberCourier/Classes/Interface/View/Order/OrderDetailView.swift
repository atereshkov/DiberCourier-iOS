//
//  OrderDetailView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/3/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import UIKit

protocol OrderDetailViewDelegate: class {
    func showFromAddreesDetails()
    func showToAddressDetails()
}

class OrderDetailView: UIView {
    
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: OrderDetailViewDelegate?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: Public API
    
    func set(order: OrderView) {
        fromAddressLabel.text = order.addressFrom.address
        toAddressLabel.text = order.addressTo.address
        descriptionLabel.text = order.descr
        dateLabel.text = "\(order.date)"
    }
    
    // MARK: Actions
    
    @IBAction func fromAddressPressed(_ sender: Any) {
        delegate?.showFromAddreesDetails()
    }
    
    @IBAction func toAddressPressed(_ sender: Any) {
        delegate?.showToAddressDetails()
    }
    
}
