//
//  OAuth2Handler.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Alamofire

class OAuth2Handler: RequestAdapter, RequestRetrier {
    
    fileprivate typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    fileprivate weak var sessionManager: SessionManager?
    fileprivate let lock = NSLock()
    fileprivate var isRefreshing = false
    fileprivate var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(_ sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if (urlRequest.url?.absoluteString.contains(Endpoint.auth.rawValue))! {
            urlRequest.setValue(NetworkConstant.authorizationValue, forHTTPHeaderField: NetworkConstant.headerAuthorization)
        } else {
            urlRequest.setValue("Bearer \(PreferenceManager.shared.token)", forHTTPHeaderField: NetworkConstant.headerAuthorization)
        }
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken, refreshToken in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        let url = Endpoint.auth.url()
        
        let params: [String: String] = [
            NetworkConstant.grantType: NetworkConstant.refreshToken,
            NetworkConstant.clientId: NetworkConstant.clientIdValue,
            NetworkConstant.refreshToken: PreferenceManager.shared.refreshToken
        ]
        
        LogManager.log.info("Refresh token")
        Swift.print(params)
        
        sessionManager?.request(url, method: .post, parameters: params)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                if
                    let json = response.result.value as? [String: Any],
                    let accessToken = json["access_token"] as? String,
                    let refreshToken = json["refresh_token"] as? String
                {
                    PreferenceManager.shared.token = accessToken
                    PreferenceManager.shared.refreshToken = refreshToken
                    completion(true, accessToken, refreshToken)
                } else {
                    let notification = Notification(name: .AuthenticationExpired)
                    NotificationCenter.default.post(notification)
                    completion(false, nil, nil)
                }
                
                strongSelf.isRefreshing = false
        }
    }
}

extension Notification.Name {
    static let AuthenticationExpired = Notification.Name("NotificationAuthenticationExpired")
}

