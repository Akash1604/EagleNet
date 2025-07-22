//
//  HTTPMethod.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

/// Represents HTTP request methods used in network operations.
///
/// This struct provides a type-safe way to specify HTTP methods for network requests.
/// EagleNet supports the standard HTTP methods: GET, POST, PUT, and DELETE.
///
/// ## Usage
/// ```swift
/// // Using predefined HTTP methods
/// let getRequest = DataRequest(
///     url: "https://api.example.com/users",
///     httpMethod: .get
/// )
///
/// let postRequest = DataRequest(
///     url: "https://api.example.com/users",
///     httpMethod: .post,
///     body: newUser
/// )
///
/// // Custom HTTP method if needed
/// let patch = HTTPMethod(rawValue: "PATCH")
/// ```
public struct HTTPMethod: RawRepresentable, Sendable {
    /// The string representation of the HTTP method
    public let rawValue: String

    /// Creates a new HTTP method with the specified raw value
    /// - Parameter rawValue: The string representation of the HTTP method
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /// HTTP GET method for retrieving resources
    public static let get = HTTPMethod(rawValue: "GET")

    /// HTTP POST method for creating resources
    public static let post = HTTPMethod(rawValue: "POST")

    /// HTTP PUT method for updating resources
    public static let put = HTTPMethod(rawValue: "PUT")

    /// HTTP DELETE method for removing resources
    public static let delete = HTTPMethod(rawValue: "DELETE")
}
