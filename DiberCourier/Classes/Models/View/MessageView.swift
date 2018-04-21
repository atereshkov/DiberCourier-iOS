//
//  MessageView.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 4/21/18.
//  Copyright © 2018 Diber. All rights reserved.
//

import Foundation

class MessageView {
    
    private(set) var id: Int
    private(set) var message: String
    private(set) var createdDate: Date = Date(timeIntervalSince1970: 1)
    private(set) var updatedDate: Date = Date(timeIntervalSince1970: 1)
    private(set) var user: UserView
    
    init(id: Int, message: String, createdDate: Date, updatedDate: Date, user: UserView) {
        self.id = id
        self.message = message
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.user = user
    }
    
}

extension MessageView {
    
    class func create(from dto: MessageDTO) -> MessageView? {
        guard let userDto = dto.user, let user = UserView.create(from: userDto) else { return nil }
        let id = dto.id
        let message = dto.message
        let createdDate = dto.createdDate
        let updatedDate = dto.updatedDate
        
        return MessageView(id: id, message: message, createdDate: createdDate, updatedDate: updatedDate, user: user)
    }
    
    class func from(_ messages: [MessageDTO]) -> [MessageView] {
        var messagesDVO = [MessageView]()
        
        for messageDTO in messages {
            if let message = MessageView.create(from: messageDTO) {
                messagesDVO.append(message)
            }
        }
        
        return messagesDVO
    }
    
}
