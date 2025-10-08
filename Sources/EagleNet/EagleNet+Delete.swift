//
//  EagleNet+Delete.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

/// Extension providing DELETE request convenience methods for EagleNet
extension EagleNet {
    /// Performs a DELETE request
    ///
    /// Example usage:
    /// ```swift
    /// struct DeleteParams: Encodable {
    ///     let reason: String
    ///     let permanent: Bool
    /// }
    ///
    /// let params = DeleteParams(reason: "Account closed", permanent: true)
    /// let response: DeleteResponse = try await EagleNet.delete(
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
    ///   - body: Optional request body (any Encodable type or Data)
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the request fails or response cannot be decoded
    public static func delete<Response: Decodable>(
        url: any URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: Body? = nil
    ) async throws -> Response {
        try await networkService.execute(
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
