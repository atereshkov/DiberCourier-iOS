//
//  Order.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

class OrderDTO {
    
    private(set) var id: Int
    private(set) var date: Date = Date(timeIntervalSince1970: 1)
    private(set) var descr: String
    private(set) var price: Double
    private(set) var status: String
    private(set) var addressFrom: AddressDTO? = nil
    private(set) var addressTo: AddressDTO? = nil
    private(set) var courier: User? = nil
    private(set) var customer: User? = nil
    
    init(id: Int, date: Date, descr: String, price: Double, status: String, addressFrom: AddressDTO? = nil, addressTo: AddressDTO? = nil, courier: User? = nil, customer: User? = nil) {
        self.id = id
        self.date = date
        self.descr = descr
        self.price = price
        self.status = status
        self.addressTo = addressTo
        self.addressFrom = addressFrom
        self.courier = courier
        self.customer = customer
    }
    
}

// MARK: Serialization

extension OrderDTO {
    
    class func with(data: [String: Any]) -> OrderDTO? {
        guard let id = data["id"] as? Int, let timestamp = data["date"] as? TimeInterval, let price = data["price"] as? Double, let status = data["status"] as? String else {
            LogManager.log.error("Failed to parse Order")
            return nil
        }
        let descr = data["description"] as? String ?? ""
        let date = Date(timeIntervalSince1970: timestamp)
        
        var addressTo: AddressDTO?
        if let addressToData = data["addressTo"] as? [String: Any] {
            addressTo = AddressDTO.with(data: addressToData)
        }
        var addressFrom: AddressDTO?
        if let addressFromData = data["addressFrom"] as? [String: Any] {
            addressFrom = AddressDTO.with(data: addressFromData)
        }
        var courier: User?
        if let courierData = data["courier"] as? [String: Any] {
            courier = User.with(data: courierData)
        }
        var customer: User?
        if let customerData = data["customer"] as? [String: Any] {
            customer = User.with(data: customerData)
        }
        
        return OrderDTO(id: id, date: date, descr: descr, price: price, status: status, addressFrom: addressFrom, addressTo: addressTo, courier: courier, customer: customer)
    }
}


