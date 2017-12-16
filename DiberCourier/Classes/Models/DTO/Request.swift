//
//  Request.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/26/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

class RequestDTO {
    
    var id: Int
    var status: String
    var order: OrderDTO
    
    init(id: Int, status: String, order: OrderDTO) {
        self.id = id
        self.status = status
        self.order = order
    }
    
}

// MARK: Serialization

extension RequestDTO {
    
    class func with(data: [String: Any]) -> RequestDTO? {
        guard let id = data["id"] as? Int, let status = data["status"] as? String, let orderData = data["order"] as? [String: Any], let order = OrderDTO.with(data: orderData) else {
            LogManager.log.error("Failed to parse RequestDTO")
            return nil
        }
        
        return RequestDTO(id: id, status: status, order: order)
    }
}
