//
//  RoundedStyledButton.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 1/13/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundedStyledButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? cornerRadius : 0
        layer.masksToBounds = rounded ? true : false
    }
    
}
