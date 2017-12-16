//
//  OrderService.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import Async
import Alamofire

class OrderService: NSObject {
    
    static let shared = OrderService()
    let sessionManager = NetworkManager.shared.sessionManager
    
    enum OrdersResult {
        case Success(orders: [OrderDTO], totalPages: Int, totalElements: Int)
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    enum OrderResult {
        case Success(order: OrderDTO)
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    enum AddRequestResult {
        case Success()
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    func getOrders(page: Int, size: Int, callback:((_ result: OrdersResult) -> ())? = nil) {
        let url = OrderEndpoint.orders(page: page, size: size).url
        
        sessionManager.request(url)
            .validate()
            .responseJSON { response in
                var orders = [OrderDTO]()
                if response.result.error == nil, let data = response.result.value as? [String: Any] {
                    if let ordersData = data["content"] as? [[String: Any]] {
                        for orderData in ordersData {
                            if let order = OrderDTO.with(data: orderData) {
                                orders.append(order)
                            }
                        }
                    }
                    let totalPages = data["totalPages"] as? Int ?? 0
                    let totalElements = data["totalElements"] as? Int ?? 0
                    callback?(OrdersResult.Success(orders: orders, totalPages: totalPages, totalElements: totalElements))
                } else {
                    callback?(OrdersResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
    func getOrder(id: Int, callback:((_ result: OrderResult) -> ())? = nil) {
        let url = OrderEndpoint.order(id: id).url
        
        sessionManager.request(url)
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
    }
    
    func addRequest(orderId: Int, callback:((_ result: AddRequestResult) -> ())? = nil) {
        let url = OrderEndpoint.addRequest(orderId: orderId).url
        
        let orderId: [String: Any] = [ "id": orderId ]
        let courierid: [String: Any] = [ "id": PreferenceManager.shared.userId ]
        
        let params: [String: Any] = [
            "order": orderId,
            "courier": courierid
        ]
        
        sessionManager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if response.result.error == nil, let _ = response.result.value as? [String: Any] {
                    callback?(AddRequestResult.Success())
                } else {
                    callback?(AddRequestResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
}
