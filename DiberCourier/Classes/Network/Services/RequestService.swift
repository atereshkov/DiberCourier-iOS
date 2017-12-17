//
//  RequestService.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 12/17/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import Async
import Alamofire

class RequestService: NSObject {
    
    static let shared = RequestService()
    let sessionManager = NetworkManager.shared.sessionManager
    
    enum RequestsResult {
        case Success(requests: [RequestDTO])
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    enum RequestResult {
        case Success(request: RequestDTO)
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    enum CancelRequestResult {
        case Success()
        case OfflineError
        case UnexpectedError(error: Error?)
    }
    
    func getRequests(callback:((_ result: RequestsResult) -> ())? = nil) {
        let userId = PreferenceManager.shared.userId
        let url = RequestEndpoint.requests(userId: userId).url
        
        sessionManager.request(url)
            .validate()
            .responseJSON { response in
                var requests = [RequestDTO]()
                if response.result.error == nil, let requestsData = response.result.value as? [[String: Any]] {
                    for requestData in requestsData {
                        if let request = RequestDTO.with(data: requestData) {
                            requests.append(request)
                        }
                    }
                    callback?(RequestsResult.Success(requests: requests))
                } else {
                    callback?(RequestsResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
    func getRequest(id: Int, callback:((_ result: RequestResult) -> ())? = nil) {
        let url = RequestEndpoint.request(id: id).url
        
        sessionManager.request(url)
            .validate()
            .responseJSON { response in
                if response.result.error == nil, let data = response.result.value as? [String: Any] {
                    if let request = RequestDTO.with(data: data) {
                        callback?(RequestResult.Success(request: request))
                    }
                } else {
                    callback?(RequestResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
    func cancelRequest(id: Int, callback:((_ result: CancelRequestResult) -> ())? = nil) {
        let url = RequestEndpoint.cancel(id: id, status: RequestStatus.canceled_by_courier).url
        let method = RequestEndpoint.cancel(id: id, status: RequestStatus.canceled_by_courier).method
        let params = RequestEndpoint.cancel(id: id, status: RequestStatus.canceled_by_courier).parameters
        
        sessionManager.request(url, method: method, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if response.result.error == nil, let data = response.result.value as? [String: Any] {
                    if let _ = RequestDTO.with(data: data) {
                        callback?(CancelRequestResult.Success())
                    } else {
                        callback?(CancelRequestResult.UnexpectedError(error: response.result.error))
                    }
                } else {
                    callback?(CancelRequestResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
}
