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
public typealias ProgressHandler = (Int64, Int64) -> Void
