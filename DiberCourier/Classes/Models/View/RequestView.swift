//
//  RequestView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

class RequestView {
    
    private(set) var id: Int
    private(set) var status: RequestStatus
    private(set) var order: OrderView
    
    init(id: Int, status: RequestStatus, order: OrderView) {
        self.id = id
        self.status = status
        self.order = order
    }
    
}

extension RequestView {
    
    class func create(from request: RequestDTO) -> RequestView? {
        let id = request.id
        let status = request.status
        guard let order = OrderView.create(from: request.order) else {
            LogManager.log.error("Failed to parse RequestView from RequestDTO. Order parsing error")
            return nil
        }
        
        return RequestView(id: id, status: status, order: order)
    }
    
    class func from(requests: [RequestDTO]) -> [RequestView] {
        var requestsDVO = [RequestView]()
        
        for requestsDTO in requests {
            if let request = RequestView.create(from: requestsDTO) {
                requestsDVO.append(request)
            }
        }
        
        return requestsDVO
    }
    
}
