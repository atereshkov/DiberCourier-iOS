//
//  OrderView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import RealmSwift

class OrderView {
    
    private(set) var id: Int
    private(set) var date: Date = Date(timeIntervalSince1970: 1)
    private(set) var descr: String = ""
    private(set) var price: Double
    private(set) var status: String // TODO: change status to Enum
    private(set) var addressFrom: AddressView
    private(set) var addressTo: AddressView
    private(set) var courier: User? = nil
    private(set) var customer: User
    
    init(id: Int, date: Date, descr: String, price: Double, status: String, addressFrom: AddressView, addressTo: AddressView, courier: User? = nil, customer: User) {
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
    
    class func create(from order: OrderDTO) -> OrderView? {
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
        
        guard let addressFromView = AddressView.create(from: addressFrom), let addressToView = AddressView.create(from: addressTo) else { return nil }
        
        return OrderView(id: id, date: date, descr: descr, price: price, status: status, addressFrom: addressFromView, addressTo: addressToView, courier: courier, customer: customer)
    }
    
    class func from(orders: [OrderDTO]) -> [OrderView] {
        var ordersDVO = [OrderView]()
        
        for orderDTO in orders {
            if let order = OrderView.create(from: orderDTO) {
                ordersDVO.append(order)
            }
        }
        
        return ordersDVO
    }
    
}
