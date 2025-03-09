//
//  NetworkService+Put.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

/// Extension providing PUT request convenience methods for NetworkService
extension NetworkService {
    /// Performs a PUT request with a BodyConvertible body
    ///
    /// Example usage:
    /// ```swift
    /// let rawData = "{\"data\": \"Hello Anbu\"}".data(using: .utf8)!
    /// let response: APIResponse = try await networkService.put(
    ///     url: "https://api.example.com",
    ///     path: "/documents/123",
    ///     headers: ["Authorization": "Bearer token123"],
    ///     body: rawData
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

    /// Performs a PUT request with an Encodable body
    ///
    /// Example usage:
    /// ```swift
    /// struct UpdateUser: Encodable {
    ///     let name: String
    ///     let age: Int
    /// }
    ///
    /// let updatedUser = UpdateUser(name: "John Smith", age: 31)
    /// let response: UserResponse = try await networkService.put(
    ///     url: "https://api.example.com",
    ///     path: "/users/123",
    ///     body: updatedUser
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
