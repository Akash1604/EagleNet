//
//  URLConvertible.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

/// Error type for URL conversion failures
///
/// Used when a string cannot be converted to a valid URL
enum URLError: Error {
    /// Indicates that the provided value could not be converted to a valid URL
    case invalid
}

/// Protocol for types that can be converted to a URL
///
/// This protocol allows for flexible URL handling in network requests.
/// Both String and URL conform to this protocol by default, allowing
/// them to be used interchangeably when specifying URLs.
///
/// ## Example Usage
/// ```swift
/// // Using a string URL
/// let request1 = DataRequest(
///     url: "https://api.example.com/users",
///     httpMethod: .get
/// )
///
/// // Using a URL object
/// let url = URL(string: "https://api.example.com/users")!
/// let request2 = DataRequest(
///     url: url,
///     httpMethod: .get
/// )
/// ```
public protocol URLConvertible: Sendable {
    /// Converts the implementing type to a URL
    /// - Returns: A URL object
    /// - Throws: URLError.invalid if conversion fails
    func asURL() throws -> URL
}

public extension URLConvertible where Self == String {
    /// Converts a string to a URL
    /// - Returns: A URL created from the string
    /// - Throws: URLError.invalid if the string is not a valid URL
    func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw URLError.invalid
        }

        return url
    }
}

public extension URLConvertible where Self == URL {
    /// Returns the URL directly since it's already a URL
    /// - Returns: The URL itself
    func asURL() throws -> URL { self }
}

/// Extends String to conform to URLConvertible
extension String: URLConvertible { }

/// Extends URL to conform to URLConvertible
extension URL: URLConvertible { }
