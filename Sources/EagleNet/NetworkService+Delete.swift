//
//  NetworkService+Delete.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

/// Extension providing DELETE request convenience methods for NetworkService
extension NetworkService {
    /// Performs a DELETE request with a BodyConvertible body
    ///
    /// Example usage:
    /// ```swift
    /// // Delete a specific resource
    /// let response: DeleteResponse = try await networkService.delete(
    ///     url: "https://api.example.com",
    ///     path: "/users/123",
    ///     headers: ["Authorization": "Bearer token123"]
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
    public func delete<Response: Decodable>(
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
                httpMethod: .delete,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }

    /// Performs a DELETE request with an Encodable body
    ///
    /// Example usage:
    /// ```swift
    /// struct DeleteParams: Encodable {
    ///     let reason: String
    ///     let permanent: Bool
    /// }
    ///
    /// let params = DeleteParams(reason: "Account closed", permanent: true)
    /// let response: DeleteResponse = try await networkService.delete(
    ///     url: "https://api.example.com",
    ///     path: "/accounts/123",
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
    public func delete<Response: Decodable>(
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
                httpMethod: .delete,
                headers: headers,
                parameters: parameters,
                body: body
            )
        )
    }
}
