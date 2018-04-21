//
//  TicketView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/20/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation

class TicketView {
    
    private(set) var id: Int
    private(set) var status: String
    private(set) var title: String
    private(set) var createdDate: Date = Date(timeIntervalSince1970: 1)
    private(set) var updatedDate: Date = Date(timeIntervalSince1970: 1)
    private(set) var user: UserView
    
    init(id: Int, status: String, title: String, createdDate: Date, updatedDate: Date, user: UserView) {
        self.id = id
        self.status = status
        self.title = title
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.user = user
    }
    
}

extension TicketView {
    
    class func create(from dto: TicketDTO) -> TicketView? {
        guard let userDto = dto.user, let user = UserView.create(from: userDto) else { return nil }
        let id = dto.id
        let status = dto.status
        let title = dto.title
        let createdDate = dto.createdDate
        let updatedDate = dto.updatedDate
        
        return TicketView(id: id, status: status, title: title, createdDate: createdDate, updatedDate: updatedDate, user: user)
    }
    
    class func from(_ tickets: [TicketDTO]) -> [TicketView] {
        var ticketsDVO = [TicketView]()
        
        for ticketDTO in tickets {
            if let ticket = TicketView.create(from: ticketDTO) {
                ticketsDVO.append(ticket)
            }
        }
        
        return ticketsDVO
    }
    
}
