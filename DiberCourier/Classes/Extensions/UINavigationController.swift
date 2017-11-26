//
//  UINavigationController.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/26/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
    
}
