//
//  SessionProvider.swift
//  evo-web-example
//
//  Created by Paweł Wojtkowiak on 08/04/2019.
//  Copyright © 2019 Intelligent Payments. All rights reserved.
//

import Foundation
import EvoPayments

/// Example Evo.Session provider implementation
final class SessionProvider {
    typealias Result<Response> = Swift.Result<Response, SessionProvider.Error>
    typealias CompletionHandler = ((Result<Session>) -> Void)?
    private typealias TokenCompletionHandler = ((Result<SessionResponseData>) -> Void)?

    enum Error: Swift.Error {
        case connectionError(Swift.Error)
        case invalidStatusCode(Int)
        case invalidParamTokenUrl(String)
        case buildRequestFailed
        case responseMissing
        case dataMissing
        case decodingError(Swift.Error)
    }

    /// Obtain a Evo.Session object by using provided input data
    func requestSession(using data: SessionRequestData,
                        completionHandler: CompletionHandler) {

        let parameters = data.toDictionary()

        guard let request = sessionTokenRequest(url: data.tokenUrl,
                                                parameters: parameters) else {
            assertionFailure("Could not build request with parameters: \(parameters)")
            completionHandler?(.failure(.buildRequestFailed))
            return
        }

        send(request: request) { result in
            switch result {
            case .success(let session):
                let session = Session(mobileCashierUrl: session.mobileCashierUrl,
                                          token: session.token,
                                          merchantId: session.merchantId)

                DispatchQueue.main.async {
                    completionHandler?(.success(session))
                }
            case .failure(let error):

                DispatchQueue.main.async {
                    completionHandler?(.failure(error))
                }
            }
        }
    }

    // MARK: Private

    private func send(request: URLRequest, completionHandler: TokenCompletionHandler) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler?(.failure(.connectionError(error)))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completionHandler?(.failure(.responseMissing))
                return
            }

            guard (200 ... 299) ~= response.statusCode else {
                completionHandler?(.failure(.invalidStatusCode(response.statusCode)))
                return
            }

            guard let data = data else {
                completionHandler?(.failure(.dataMissing))
                return
            }

            do {
                let session = try SessionResponseData(data: data)
                completionHandler?(.success(session))
            } catch {
                completionHandler?(.failure(.decodingError(error)))
            }
        }

        task.resume()
    }

    private func sessionTokenRequest(url tokenURL: URL,
                                     parameters: URL.Evo.QueryParameters) -> URLRequest? {

        guard let url = tokenURL.evo.addingQueryParameters(parameters) else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        return request
    }
}
