//
//  UserView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 3/10/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation

class UserView {
    
    var id: Int
    var email: String
    var username: String
    var enabled: Bool
    var fullname: String
    var customer: Bool
    var courier: Bool
    
    init(id: Int, email: String, username: String, enabled: Bool, fullname: String, customer: Bool, courier: Bool) {
        self.id = id
        self.email = email
        self.username = username
        self.enabled = enabled
        self.fullname = fullname
        self.customer = customer
        self.courier = courier
    }
    
}

extension UserView {
    
    class func create(from dto: UserDTO) -> UserView? {
        let id = dto.id
        let email = dto.email
        let username = dto.username
        let enabled = dto.enabled
        let fullname = dto.fullname
        let customer = dto.isCustomer
        let courier = dto.isCourier
        
        return UserView(id: id, email: email, username: username, enabled: enabled, fullname: fullname, customer: customer, courier: courier)
    }
    
}
