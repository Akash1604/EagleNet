//
//  MultipartParameter.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

import Foundation

/// Represents parameters for multipart/form-data requests
///
/// This enum is used to define the different types of parameters that can be included
/// in a multipart form data request, such as file uploads and text fields.
///
/// ## Example Usage
/// ```swift
/// // Creating a file upload parameter
/// let imageData = UIImage(named: "profile")!.pngData()!
/// let fileParam = MultipartParameter.file(
///     key: "avatar",
///     fileName: "profile.png",
///     data: imageData,
///     mimeType: .pngImage
/// )
///
/// // Creating a text parameter
/// let textParam = MultipartParameter.text(key: "username", value: "john_doe")
///
/// // Using parameters in an upload request
/// let response: UploadResponse = try await EagleNet.upload(
///     url: "https://api.example.com/upload",
///     parameters: [fileParam, textParam],
///     progress: { bytesTransferred, totalBytes in
///         let progress = Float(bytesTransferred) / Float(totalBytes)
///         print("Upload progress: \(Int(progress * 100))%")
///     }
/// )
/// ```
public enum MultipartParameter {
    /// Represents a file to be uploaded
    /// - Parameters:
    ///   - key: Form field name for the file
    ///   - fileName: Name of the file
    ///   - data: Binary data of the file
    ///   - mimeType: Content type of the file (e.g., image/jpeg)
    case file(
        key: String,
        fileName: String,
        data: Data,
        mimeType: ContentType
    )

    /// Represents a text field in the form
    /// - Parameters:
    ///   - key: Form field name
    ///   - value: Text value for the field
    case text(key: String, value: String)
}
