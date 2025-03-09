//
//  NetworkService+Upload.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

/// Extension providing file upload convenience methods for NetworkService
extension NetworkService {
    /// Performs a multipart form-data upload request
    ///
    /// Example usage:
    /// ```swift
    /// // Upload an image with additional form fields
    /// let imageData = // ... your image data ...
    /// let response: UploadResponse = try await networkService.upload(
    ///     url: "https://api.example.com",
    ///     path: "/upload",
    ///     headers: ["Authorization": "Bearer token123"],
    ///     parameters: [
    ///         .file(
    ///             key: "avatar",
    ///             fileName: "profile.jpg",
    ///             data: imageData,
    ///             mimeType: .jpegImage
    ///         ),
    ///         .text(key: "username", value: "johndoe")
    ///     ],
    ///     progress: { bytesUploaded, totalBytes in
    ///         let percentage = Float(bytesUploaded) / Float(totalBytes) * 100
    ///         print("Upload progress: \(Int(percentage))%")
    ///     }
    /// )
    /// ```
    ///
    /// - Parameters:
    ///   - url: The base URL for the upload request
    ///   - path: Optional path to append to the URL
    ///   - headers: Optional HTTP headers
    ///   - queryParameters: Optional URL query parameters
    ///   - parameters: Array of MultipartParameter (files and text fields)
    ///   - progress: Optional closure to track upload progress
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the upload fails or response cannot be decoded
    public func upload<Response: Decodable>(
        url: URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        parameters: [MultipartParameter] = [],
        progress: ProgressHandler? = nil
    ) async throws -> Response {
        var request = MultipartRequest(
            url: url,
            path: path,
            httpMethod: .post,
            headers: headers,
            parameters: queryParameters
        )

        for parameter in parameters {
            switch parameter {
            case .file(let key, let fileName, let data, let mimeType):
                request.addBodyParameter(
                    key: key,
                    value: data,
                    fileName: fileName,
                    contentType: mimeType
                )
            case .text(let key, let value):
                request.addBodyParameter(
                    key: key,
                    value: value
                )
            }
        }

        return try await upload(request, progress: progress)
    }
}
