//
//  RequestProtocol.swift
//  SimpleDictionary
//
//  Created by Can Bas on 27.04.2023.
//

import Foundation

import Foundation

protocol RequestProtocol {
    var path: String { get }
    var host: String {get}
    var query: String { get }
    var requestType: RequestType { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
}

extension RequestProtocol {
    var host: String {
        ""
    }

    var query: String {
        ""
    }

    var params: [String: Any] {
        [:]
    }

    var urlParams: [String: String?] {
        [:]
    }

    var headers: [String: String] {
        [:]
    }

    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path + query

        if !urlParams.isEmpty {
            components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
        }

        guard let url = components.url else { throw  NetworkError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }

        return urlRequest
    }
}
