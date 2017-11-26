//
//  OrderView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import RealmSwift

class OrderView {
    
    var id: Int
    var date: Date = Date(timeIntervalSince1970: 1)
    var descr: String = ""
    var price: Double
    var status: String
    var addressFrom: Address
    var addressTo: Address
    var courier: User? = nil
    var customer: User
    
    init(id: Int, date: Date, descr: String, price: Double, status: String, addressFrom: Address, addressTo: Address, courier: User? = nil, customer: User) {
        self.id = id
        self.date = date
        self.descr = descr
        self.price = price
        self.status = status
        self.addressFrom = addressFrom
        self.addressTo = addressTo
        self.courier = courier
        self.customer = customer
    }
    
}

extension OrderView {
    
    class func create(from order: Order) -> OrderView? {
        guard let addressFrom = order.addressFrom, let addressTo = order.addressTo, let customer = order.customer else {
            LogManager.log.info("Failed to map OrderView from Order. AddressFrom or AddressTo or Customer is nil")
            return nil
        }
        
        let id = order.id
        let date = order.date
        let descr = order.descr
        let price = order.price
        let status = order.status
        let courier = order.courier
        
        return OrderView(id: id, date: date, descr: descr, price: price, status: status, addressFrom: addressFrom, addressTo: addressTo, courier: courier, customer: customer)
    }
    
    class func from(orders: Results<Order>) -> [OrderView] {
        var ordersDVO = [OrderView]()
        
        for orderDBO in orders {
            if let order = OrderView.create(from: orderDBO) {
                ordersDVO.append(order)
            }
        }
        
        return ordersDVO
    }
    
    class func from(orders: [Order]) -> [OrderView] {
        var ordersDVO = [OrderView]()
        
        for orderDBO in orders {
            if let order = OrderView.create(from: orderDBO) {
                ordersDVO.append(order)
            }
        }
        
        return ordersDVO
    }
    
}
