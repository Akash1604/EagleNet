//
//  BodyConvertible.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

/// Protocol for types that can be converted to request body data
///
/// This protocol allows for flexible handling of request bodies in network requests.
/// It extends `Encodable` to provide a standard way to convert objects to Data
/// for use in HTTP request bodies.
///
/// ## Example Usage
/// ```swift
/// // Using an Encodable struct as request body
/// struct User: Encodable {
///     let name: String
///     let email: String
/// }
///
/// let newUser = User(name: "John", email: "john@example.com")
/// let response: UserResponse = try await EagleNet.post(
///     url: "https://api.example.com/users",
///     body: newUser
/// )
///
/// // Using raw Data as request body
/// let jsonData = "{ \"name\": \"John\" }".data(using: .utf8)!
/// let response: UserResponse = try await EagleNet.post(
///     url: "https://api.example.com/users",
///     body: jsonData
/// )
/// ```
public protocol BodyConvertible: Encodable, Sendable {
    /// Converts the implementing type to Data for use in request bodies
    /// - Parameter encoder: JSONEncoder to use for encoding
    /// - Returns: Data representation of the object
    /// - Throws: Error if encoding fails
    func asBody(encoder: JSONEncoder) throws -> Data
}

extension BodyConvertible where Self == Data {
    /// Implementation for Data type that returns the data directly
    /// - Parameter encoder: JSONEncoder (unused for Data type)
    /// - Returns: The Data itself
    public func asBody(encoder: JSONEncoder = .init()) throws -> Data {
        return self
    }
}

/// Extends Data to conform to BodyConvertible
extension Data: BodyConvertible { }

extension BodyConvertible {
    /// Default implementation that encodes the object using JSONEncoder
    /// - Parameter encoder: JSONEncoder to use for encoding
    /// - Returns: JSON data representation of the object
    /// - Throws: Error if JSON encoding fails
    func asBody(encoder: JSONEncoder = .init()) throws -> Data {
        try encoder.encode(self)
    }
}

extension Encodable {
    /// Converts any Encodable type to a BodyConvertible
    /// - Returns: A BodyConvertible wrapper around the Encodable object
    func asBodyConvertible() -> BodyConvertible {
        AnyBodyConvertible(body: self)
    }
}

/// Type-erased wrapper for Encodable types to make them conform to BodyConvertible
struct AnyBodyConvertible<T>: BodyConvertible, @unchecked Sendable where T: Encodable {
    /// The wrapped Encodable object
    let body: T

    /// Converts the wrapped object to Data
    /// - Parameter encoder: JSONEncoder to use for encoding
    /// - Returns: JSON data representation of the wrapped object
    /// - Throws: Error if JSON encoding fails
    func asBody(encoder: JSONEncoder) throws -> Data {
        try encoder.encode(body)
    }
}
