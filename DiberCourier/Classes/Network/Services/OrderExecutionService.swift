//
//  OrderExecutionService.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 1/21/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation
import Async
import Alamofire

class OrderExecutionService: NSObject {
    
    static let shared = OrderExecutionService()
    let sessionManager = NetworkManager.shared.sessionManager
    
    enum StartExecutionResult {
        case Success()
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    func startOrder(id: Int, status: OrderExecution, callback:((_ result: StartExecutionResult) -> ())? = nil) {
        let endpoint = OrderExecutionEndpoint.startOrder(id: id, status: status)
        
        // TODO
        /*
        sessionManager.request(endpoint.url)
            .validate()
            .responseJSON { response in
                if response.result.error == nil, let data = response.result.value as? [String: Any] {
                    if let order = OrderDTO.with(data: data) {
                        callback?(OrderResult.Success(order: order))
                    }
                } else {
                    callback?(OrderResult.UnexpectedError(error: response.result.error))
                }
        }
        */
    }
    
}
