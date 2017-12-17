//
//  Constants.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation

enum Segues: String {
    case mainScreen = "MainScreen"
    case loginFromMain = "LoginFromMain"
    case ordersTable = "OrdersTableVC"
    case requestsTable = "RequestsTableVC"
    case showOrderDetails = "ShowOrderDetails"
    case showRequestDetails = "ShowRequestDetails"
    case ordersDropDown = "OrdersDropDown"
}

enum Storyboards: String {
    case order = "Order"
    case request = "Request"
}

enum Cells: String {
    case orders = "OrderCell"
    case requests = "RequestCell"
}

class NetworkConstant {
    static let grantType = "grant_type"
    static let clientId = "client_id"
    static let clientIdValue = "clientapp"
    static let refreshToken = "refresh_token"
    static let username = "username"
    static let password = "password"
    
    static let headerAuthorization = "Authorization";
    static let authorizationValue = "Basic Y2xpZW50YXBwOjEyMzQ1Ng==";
}

class Pagination {
    static let pageSize = 5 // items number for pagination loading
}
