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
    case recentOrdersTable = "RecentOrdersTableVC"
    case requestsTable = "RequestsTableVC"
    case showOrderDetails = "ShowOrderDetails"
    case showRequestDetails = "ShowRequestDetails"
    case ordersMainHeader = "ordersMainHeader"
}

enum Storyboards: String {
    case order = "Order"
    case request = "Request"
    case orderExecution = "OrderExecution"
    case map = "GoogleMap"
}

enum Cells: String {
    case orders = "OrderCell"
    case recentOrder = "RecentOrderCell"
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
    static let pageSize = 6 // items number for pagination loading
    static let cellOffset = 120.0 // offset for pagination loading between screen bottom and scrubber
}

class GoogleMaps {
    static let apiURL = "https://www.google.com/maps/search/?api=1&query="
}
