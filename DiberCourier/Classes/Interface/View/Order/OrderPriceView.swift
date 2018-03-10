//
//  OrderPriceView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/3/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import UIKit

class OrderPriceView: UIView {
    
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Public API
    
    func setPrice(_ price: Double) {
        // TODO currency depends on the server
        priceLabel.text = "$\(price)"
    }
    
}
