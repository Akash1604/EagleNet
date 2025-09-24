//
//  HTTPContentType.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation

/// Represents HTTP Content-Type header values
///
/// This struct provides a type-safe way to specify content types for network requests.
/// It includes common predefined content types and supports custom content types.
///
/// ## Example Usage
/// ```swift
/// // Using predefined content types
/// let jsonRequest = DataRequest(
///     url: "https://api.example.com/users",
///     httpMethod: .post,
///     body: user,
///     contentType: .applicationJSON
/// )
///
/// // Using custom content type
/// let customType = ContentType("application/xml")
/// let xmlRequest = DataRequest(
///     url: "https://api.example.com/data",
///     httpMethod: .post,
///     body: xmlData,
///     contentType: customType
/// )
/// ```
public struct ContentType: CustomStringConvertible, Sendable {
    /// The string representation of the content type
    let rawValue: String

    /// String description that returns the raw value
    public var description: String { rawValue }

    /// Creates a new content type with the specified raw value
    /// - Parameter rawValue: The string representation of the content type
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

/// Allows ContentType to be created from string literals
extension ContentType: ExpressibleByStringLiteral {
    /// Creates a content type from a string literal
    /// - Parameter value: String literal value
    public init(stringLiteral value: StringLiteralType) {
        rawValue = value
    }
}

public extension ContentType {
    /// Plain text content type (text/plain)
    static let textPlain: ContentType = "text/plain"

    /// JSON content type (application/json)
    static let applicationJSON: ContentType = "application/json"

    /// Multipart form data content type (multipart/form-data)
    static let multipartFormData: ContentType = "multipart/form-data"

    /// Binary data content type (application/octet-stream)
    static let applicationOctetStream: ContentType = "application/octet-stream"

    /// PNG image content type (image/png)
    static let pngImage: ContentType = "image/png"

    /// JPEG image content type (image/jpeg)
    static let jpegImage: ContentType = "image/jpeg"
}
