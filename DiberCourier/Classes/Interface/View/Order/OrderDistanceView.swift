//
//  OrderDistanceView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 3/10/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import UIKit

class OrderDistanceView: UIView {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Public API
    
    func set(distance: Double) {
        let km = distance / 1000 // km
        distanceLabel.text = String(format: "%.2f km", km)
    }
    
}
