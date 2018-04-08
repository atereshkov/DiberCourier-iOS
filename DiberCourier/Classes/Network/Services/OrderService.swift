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
    
    enum CompleteOrderResult {
        case Success()
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    enum CancelOrderResult {
        case Success()
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    func getOrders(page: Int, size: Int, callback:((_ result: OrdersResult) -> ())? = nil) {
        let endpoint = OrderEndpoint.orders(page: page, size: size)
        
        sessionManager.request(endpoint.url)
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
    
    func getOrders(query: String, page: Int, size: Int,
                   callback:((_ result: OrdersResult) -> ())? = nil) {
        let endpoint = OrderEndpoint.searchOrders(query: query, page: page, size: size)
        
        sessionManager.request(endpoint.url)
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
        let endpoint = OrderEndpoint.order(id: id)
        
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
    }
    
    func completeOrder(id: Int, callback:((_ result: CompleteOrderResult) -> ())? = nil) {
        let endpoint = OrderEndpoint.complete(id: id, status: OrderStatus.completed_by_courier)
        
        sessionManager.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if response.result.error == nil, let data = response.result.value as? [String: Any] {
                    if let _ = OrderDTO.with(data: data) {
                        callback?(CompleteOrderResult.Success())
                    } else {
                        callback?(CompleteOrderResult.UnexpectedError(error: response.result.error))
                    }
                } else {
                    callback?(CompleteOrderResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
    func cancelOrder(id: Int, callback:((_ result: CancelOrderResult) -> ())? = nil) {
        let endpoint = OrderEndpoint.cancel(id: id, status: OrderStatus.canceled_by_courier)
        
        sessionManager.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if response.result.error == nil, let data = response.result.value as? [String: Any] {
                    if let _ = OrderDTO.with(data: data) {
                        callback?(CancelOrderResult.Success())
                    } else {
                        callback?(CancelOrderResult.UnexpectedError(error: response.result.error))
                    }
                } else {
                    callback?(CancelOrderResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
}
