//
//  Request.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/26/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

class RequestDTO {
    
    var orderId: Int
    var courierId: Int
    
    init(orderId: Int, courierId: Int) {
        self.orderId = orderId
        self.courierId = courierId
    }
    
}

extension AddressView {
    
    class func toJSON() -> [String: Any] {
        return [:]
    }
    
}
