//
//  IPGConnection.swift
//  ipg-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Paweł Wojtkowiak. All rights reserved.
//

import Foundation

final class IPGConnection {
    typealias CompletionHandler = ((IPG.Result<IPG.SessionData>) -> Void)?
    private typealias TokenCompletionHandler = ((IPG.Result<String>) -> Void)?
    
    private(set) var sessionData: IPG.SessionData?
    
    private let environment: IPG.Environment
    private let factory: IPGRequestFactory
    
    init(environment: IPG.Environment) {
        self.environment = environment
        self.factory = IPGRequestFactory(environment: environment)
    }
    
    func requestSessionData(data: IPG.SessionTokenRequestData,
                            completionHandler: CompletionHandler) {
        
        var params = [String: CustomStringConvertible]()
        params["merchantId"] = data.merchantID
        params["password"] = data.password
        params["allowOriginUrl"] = data.allowOriginUrl
        params["action"] = data.action.rawValue
        params["timestamp"] = data.timestamp
        params["amount"] = data.amount
        params["channel"] = data.channel.rawValue
        params["currency"] = data.currency
        params["country"] = data.country
        params["paymentSolutionId"] = data.paymentSolution.rawValue
        params["customerId"] = data.customerID
        
        guard let request = factory.sessionTokenRequest(parameters: params) else {
            completionHandler?(.error(
                .buildRequestError("Could not build request: \(#function), params: \(params)")
            ))
            return
        }
        
        send(request: request) { result in
            switch result {
            case .success(let token):
                let session = IPG.SessionData(token: token,
                                              merchantId: data.merchantID)
                completionHandler?(.success(session))
            case .error(let error):
                completionHandler?(.error(error))
            }
        }
    }
    
    // MARK: Private
    
    private func send(request: URLRequest, completionHandler: TokenCompletionHandler) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse, error == nil else {
                completionHandler?(.error(.connection(error)))
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                completionHandler?(.error(.statusCode(error)))
                return
            }
            
            guard let data = data else {
                completionHandler?(.error(.responseMissing))
                return
            }
            
            if let token = String(data: data, encoding: .utf8) {
                completionHandler?(.success(token))
            } else {
                completionHandler?(.error(.responseInvalid))
            }
        }
        
        task.resume()
    }
}
