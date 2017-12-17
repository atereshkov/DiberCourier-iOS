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
    var status: RequestStatus
    var order: OrderDTO
    var date: Date = Date(timeIntervalSince1970: 1)
    
    init(id: Int, status: RequestStatus, order: OrderDTO, date: Date) {
        self.id = id
        self.status = status
        self.order = order
        self.date = date
    }
    
}

// MARK: Serialization

extension RequestDTO {
    
    class func with(data: [String: Any]) -> RequestDTO? {
        guard let id = data["id"] as? Int, let statusData = data["status"] as? String, let status = RequestStatus(rawValue: statusData), let orderData = data["order"] as? [String: Any], let order = OrderDTO.with(data: orderData) else {
            LogManager.log.error("Failed to parse RequestDTO")
            return nil
        }
        
        let timestamp = data["creation_date"] as? TimeInterval ?? 0
        let date = Date(timeIntervalSince1970: timestamp)
        
        return RequestDTO(id: id, status: status, order: order, date: date)
    }
}
