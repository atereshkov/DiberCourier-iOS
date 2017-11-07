//
//  Address.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/7/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import RealmSwift

class Address: RealmObject {
    
    @objc private(set) dynamic var id: Int = -1
    @objc private(set) dynamic var name: String = ""
    @objc private(set) dynamic var postalCode: Int = 0
    @objc private(set) dynamic var country: String = ""
    @objc private(set) dynamic var city: String = ""
    @objc private(set) dynamic var region: String = ""
    @objc private(set) dynamic var address: String = ""
    @objc private(set) dynamic var phone: String = ""
    
    convenience init(id: Int, name: String, postalCode: Int, country: String, city: String, region: String, address: String, phone: String) {
        self.init()
        self.id = id
        self.name = name
        self.postalCode = postalCode
        self.country = country
        self.city = city
        self.region = region
        self.address = address
        self.phone = phone
    }
    
    // MARK: Realm
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: Serialization

extension Address {
    
    class func with(data: [String: Any]) -> Address? {
        guard let id = data["id"] as? Int, let name = data["name"] as? String, let address = data["address"] as? String, let country = data["country"] as? String, let phone = data["phone"] as? String, let city = data["city"] as? String else {
            LogManager.log.error("Failed to parse Address")
            return nil
        }
        let region = data["region"] as? String ?? ""
        let postalCode = data["postalCode"] as? Int ?? 0
        
        return Address(id: id, name: name, postalCode: postalCode, country: country, city: city, region: region, address: address, phone: phone)
    }
}

