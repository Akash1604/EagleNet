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
///     case .parsingError(let reason):
///         print("Failed to parse response: \(reason)")
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
    /// - Parameter reason: Description of why parsing failed
    case parsingError(reason: String)
    
    /// Indicates that the provided value could not be converted to a valid URL
    case invalidURL
}
