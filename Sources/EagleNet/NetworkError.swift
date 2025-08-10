//
//  NetworkError.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

/// Represents errors that can occur during network operations
///
/// This enum defines the different types of errors that can occur when making
/// network requests with EagleNet, including HTTP errors and parsing failures.
///
/// ## Example Usage
/// ```swift
/// do {
///     let user: User = try await EagleNet.get(url: "https://api.example.com/users/1")
///     // Process successful response
/// } catch let error as NetworkError {
///     switch error {
///     case .failure(let message, let statusCode, let data):
///         print("Network error: \(message), status code: \(statusCode)")
///         if let errorData = data {
///             print("Response data: \(String(data: errorData, encoding: .utf8) ?? "Invalid data")")
///         }
///     case .parsingError(let error):
///         print("Failed to parse response: \(error)")
///     }
/// } catch {
///     print("Unexpected error: \(error)")
/// }
/// ```
public enum NetworkError: Error {
    /// Represents an HTTP request failure
    /// - Parameters:
    ///   - message: Description of the error
    ///   - statusCode: HTTP status code
    ///   - data: Optional raw response data for debugging or custom error parsing
    case failure(message: String, statusCode: Int, data: Data?)
    
    /// Represents an error that occurred during response parsing
    /// - Parameter error: The underlying parsing error
    case parsingError(error: Error)
    
    /// Indicates that the provided value could not be converted to a valid URL
    case invalidURL
}

extension NetworkError: CustomStringConvertible, CustomDebugStringConvertible {
    /// Human-readable description of the network error
    public var description: String {
        return switch self {
        case .failure(message: let message, statusCode: let statusCode, _):
            "Network request failure.\nMessage: \(message)\nStatus Code:\(statusCode)"
        case .parsingError(error: let error): "Error while parsing the response:\n\(error)"
        case .invalidURL: "Invalid request URL"
        }
    }
    
    /// Debug description (same as description for NetworkError)
    public var debugDescription: String { description }
}
