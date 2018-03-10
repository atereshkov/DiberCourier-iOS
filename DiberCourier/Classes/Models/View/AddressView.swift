//
//  AddressView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

class AddressView {
    
    private(set) var id: Int
    private(set) var name: String
    private(set) var postalCode: Int?
    private(set) var country: String
    private(set) var city: String
    private(set) var region: String?
    private(set) var address: String
    private(set) var phone: String
    private(set) var longitude: Double?
    private(set) var latitude: Double?
    
    init(id: Int, name: String, postalCode: Int? = nil, country: String, city: String, region: String? = nil, address: String, phone: String, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.postalCode = postalCode
        self.country = country
        self.city = city
        self.region = region
        self.address = address
        self.phone = phone
        self.latitude = lat
        self.longitude = lon
    }
    
}

extension AddressView {
    
    class func create(from address: AddressDTO) -> AddressView? {
        let id = address.id
        let name = address.name
        let postalCode = address.postalCode
        let country = address.country
        let city = address.city
        let addressStr = address.address
        let phone = address.phone
        let longitude = address.longitude
        let latitude = address.latitude
        
        return AddressView(id: id, name: name, postalCode: postalCode, country: country, city: city, address: addressStr, phone: phone, lat: latitude, lon: longitude)
    }
    
    class func from(addresses: [AddressDTO]) -> [AddressView] {
        var addressesDVO = [AddressView]()
        
        for addressDTO in addresses {
            if let address = AddressView.create(from: addressDTO) {
                addressesDVO.append(address)
            }
        }
        
        return addressesDVO
    }
    
}
