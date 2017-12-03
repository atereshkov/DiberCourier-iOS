//
//  OrderRequestView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/3/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import UIKit

protocol OrderRequestViewDelegate: class {
    func executeOrderDidPress()
}

class OrderRequestView: UIView {
    
    weak var delegate: OrderRequestViewDelegate?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Actions
    
    @IBAction func executeOrderDidPress(_ sender: Any) {
        delegate?.executeOrderDidPress()
    }
    
}
