//
//  Address.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import RealmSwift

class AddressDTO {
    
    private(set) var id: Int = -1
    private(set) var name: String = ""
    private(set) var postalCode: Int = 0
    private(set) var country: String = ""
    private(set) var city: String = ""
    private(set) var region: String = ""
    private(set) var address: String = ""
    private(set) var phone: String = ""
    private(set) var longitude: Double = 0.0
    private(set) var latitude: Double = 0.0
    
    init(id: Int, name: String, postalCode: Int, country: String, city: String, region: String, address: String, phone: String, lat: Double, lon: Double) {
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

// MARK: Serialization

extension AddressDTO {
    
    class func with(data: [String: Any]) -> AddressDTO? {
        guard let id = data["id"] as? Int, let name = data["name"] as? String, let address = data["address"] as? String, let country = data["country"] as? String, let phone = data["phone"] as? String, let city = data["city"] as? String else {
            LogManager.log.error("Failed to parse Address")
            return nil
        }
        let region = data["region"] as? String ?? ""
        let postalCode = data["postalCode"] as? Int ?? 0
        let latitude = data["latitude"] as? Double ?? 0.0
        let longitude = data["longitude"] as? Double ?? 0.0
        
        return AddressDTO(id: id, name: name, postalCode: postalCode, country: country, city: city, region: region, address: address, phone: phone, lat: latitude, lon: longitude)
    }
}

