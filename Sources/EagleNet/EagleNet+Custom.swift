//
//  EagleNet+Custom.swift
//  EagleNet
//
//  Created by Anbalagan on 02/10/25.
//

extension EagleNet {
    /// Executes a custom network request with full control over request configuration
    ///
    /// This method allows you to execute custom network requests by providing your own
    /// NetworkRequestable implementation. Use this when the built-in GET, POST, PUT, DELETE
    /// methods don't provide enough flexibility for your specific use case.
    ///
    /// - Parameter request: A custom request conforming to NetworkRequestable protocol
    /// - Returns: Decoded response of the specified type
    /// - Throws: NetworkError if the request fails or response cannot be decoded
    ///
    /// ## Usage Examples
    ///
    /// ### Custom HTTP Method
    /// ```swift
    /// let patchRequest = DataRequest(
    ///     url: "https://api.example.com/users/1",
    ///     httpMethod: .custom("PATCH"),
    ///     body: ["status": "active"]
    /// )
    ///
    /// let response: User = try await EagleNet.execute(patchRequest)
    /// ```
    ///
    /// ### Custom Headers and Parameters
    /// ```swift
    /// var customRequest = DataRequest(
    ///     url: "https://api.example.com/data",
    ///     httpMethod: .get
    /// )
    /// customRequest.addHeader(key: "X-Custom-Header", value: "custom-value")
    /// customRequest.addParameter(key: "filter", value: "active")
    ///
    /// let data: APIResponse = try await EagleNet.execute(customRequest)
    /// ```
    ///
    /// ### Custom Request Implementation
    /// ```swift
    /// struct CustomRequest: NetworkRequestable {
    ///     // Custom implementation
    /// }
    ///
    /// let customRequest = CustomRequest()
    /// let result: CustomResponse = try await EagleNet.execute(customRequest)
    /// ```
    public static func execute<Response: Decodable>(
        _ request: any NetworkRequestable
    ) async throws -> Response {
        try await networkService.execute(request)
    }
}
