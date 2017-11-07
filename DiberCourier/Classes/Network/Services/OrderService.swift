//
//  OrderService.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import Async

class OrderService: NSObject {
    
    static let shared = OrderService()
    let sessionManager = NetworkManager.shared.sessionManager
    
    enum UserOrdersResult {
        case Success(orders: [Order])
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    func getOrders(callback:((_ result: UserOrdersResult) -> ())? = nil) {
        let url = OrderEndpoint.orders.url
        
        sessionManager.request(url)
            .validate()
            .responseJSON { response in
                var orders = [Order]()
                if response.result.error == nil, let data = response.result.value as? [String: Any] {
                    if let ordersData = data["content"] as? [[String: Any]] {
                        for orderData in ordersData {
                            if let order = Order.with(data: orderData) {
                                orders.append(order)
                            }
                        }
                    }
                    callback?(UserOrdersResult.Success(orders: orders))
                } else {
                    callback?(UserOrdersResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
}
