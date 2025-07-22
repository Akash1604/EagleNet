//
//  NetworkError.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

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
///     case .general(let message, let statusCode):
///         print("Network error: \(message), status code: \(statusCode)")
///     case .parsingError(let reason):
///         print("Failed to parse response: \(reason)")
///     }
/// } catch {
///     print("Unexpected error: \(error)")
/// }
/// ```
public enum NetworkError: Error {
    /// Represents a general HTTP error
    /// - Parameters:
    ///   - message: Description of the error
    ///   - statusCode: HTTP status code
    case general(message: String, statusCode: Int)
    
    /// Represents an error that occurred during response parsing
    /// - Parameter reason: Description of why parsing failed
    case parsingError(reason: String)
}
