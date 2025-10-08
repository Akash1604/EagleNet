//
//  Misc.swift
//  EagleNet
//
//  Created by Anbalagan on 08/03/25.
//

/// A handler that reports progress of an operation.
///
/// - Parameters:
///   - bytesTransferred: The number of bytes that have been transferred.
///   - totalBytes: The total number of bytes expected to be transferred.
///
/// This handler is typically used to track and report the progress of network operations
/// such as downloads or uploads, allowing for the implementation of progress indicators
/// or other user feedback mechanisms.
///
/// Example:
/// ```swift
/// let progressHandler: ProgressHandler = { bytesTransferred, totalBytes in
///     let progress = Float(bytesTransferred) / Float(totalBytes)
///     print("Progress: \(Int(progress * 100))%")
/// }
/// ```
public typealias ProgressHandler = @Sendable (Int64, Int64) -> Void

/// Type alias for request body.
///
/// Body can be any Encodable type (structs, classes, dictionaries, arrays) or raw Data.
/// When using Data, it will be sent as-is without JSON encoding.
///
/// Example:
/// ```swift
/// // Using Encodable struct
/// struct User: Encodable {
///     let name: String
/// }
/// let body: Body = User(name: "John")
///
/// // Using raw Data
/// let jsonData = "{\"name\": \"John\"}".data(using: .utf8)!
/// let body: Body = jsonData
/// ```
public typealias Body = any Encodable
