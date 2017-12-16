//
//  NetworkManager.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Alamofire

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    public var sessionManager: SessionManager
    
    private override init() {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        sessionManager = SessionManager(configuration: configuration)
        let handler = OAuth2Handler(sessionManager)
        sessionManager.adapter = handler
        sessionManager.retrier = handler
    }
    
}
