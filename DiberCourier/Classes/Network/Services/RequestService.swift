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
    
    enum AddRequestResult {
        case Success()
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
    
    func addRequest(orderId: Int, callback:((_ result: AddRequestResult) -> ())? = nil) {
        let endpoint = OrderEndpoint.addRequest(orderId: orderId)
        
        let orderId: [String: Any] = [ "id": orderId ]
        let courierId: [String: Any] = [ "id": PreferenceManager.shared.userId ]
        
        let params: [String: Any] = [
            "order": orderId,
            "courier": courierId
        ]
        
        sessionManager.request(endpoint.url, method: endpoint.method, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                if let data = response.result.value as? [String: Any] {
                    if let error = data["error_description"] as? String {
                        let customError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: error])
                        callback?(AddRequestResult.UnexpectedError(error: customError))
                    } else {
                        callback?(AddRequestResult.Success())
                    }
                } else {
                    callback?(AddRequestResult.UnexpectedError(error: response.result.error))
                }
        }
    }
    
    func cancelRequest(id: Int, callback:((_ result: CancelRequestResult) -> ())? = nil) {
        let endpoint = RequestEndpoint.cancel(id: id, status: RequestStatus.canceled_by_courier)
        
        sessionManager.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: JSONEncoding.default)
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
