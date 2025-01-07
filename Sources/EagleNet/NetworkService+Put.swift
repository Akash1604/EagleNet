//
//  NetworkService+Put.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

extension NetworkService {
    public func put<Response: Decodable>(
        url: URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: BodyConvertible? = nil
    ) async throws -> Response {
        try await execute(
            DataRequest(
                url: url,
                path: path,
                httpMethod: .put,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }
    
    public func put<Response: Decodable>(
        url: URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: (some Encodable)? = nil
    ) async throws -> Response {
        try await execute(
            DataRequest(
                url: url,
                path: path,
                httpMethod: .put,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }
}
