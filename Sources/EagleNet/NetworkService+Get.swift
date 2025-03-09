//
//  NetworkService+Get.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

/// Extension providing GET request convenience methods for NetworkService
extension NetworkService {
    /// Performs a GET request with a BodyConvertible body
    ///
    /// Example usage:
    /// ```swift
    /// let users: [User] = try await networkService.get(
    ///     url: "https://api.example.com",
    ///     path: "/users",
    ///     parameters: ["page": "1", "limit": "10"]
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - url: The base URL for the request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - parameters: Optional query parameters
    ///   - body: Optional request body conforming to BodyConvertible
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the request fails or response cannot be decoded
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

    /// Performs a GET request with an Encodable body
    ///
    /// Example usage:
    /// ```swift
    /// struct SearchParams: Encodable {
    ///     let query: String
    ///     let filter: String
    /// }
    ///
    /// let params = SearchParams(query: "swift", filter: "language")
    /// let results: SearchResults = try await networkService.get(
    ///     url: "https://api.example.com",
    ///     path: "/search",
    ///     body: params
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - url: The base URL for the request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - parameters: Optional query parameters
    ///   - body: Optional request body conforming to Encodable
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the request fails or response cannot be decoded
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
