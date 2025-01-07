//
//  NetworkService+Get.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

extension NetworkService {
    public func get<Response: Decodable>(
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
                httpMethod: .get,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }
    
    public func get<Response: Decodable>(
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
                httpMethod: .get,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }
}
