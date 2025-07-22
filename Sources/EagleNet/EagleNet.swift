//
//  EagleNet.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

/// EagleNet is a lightweight networking library built on top of URLSession.
///
/// This library provides a simple and elegant approach to writing network requests,
/// with a focus on being lightweight, maintainable, and beginner-friendly.
///
/// ## Features
/// - Basic HTTP data requests (GET, POST, PUT, DELETE)
/// - File uploads using multipart/form-data
/// - Request and response interceptors
/// - Async/await based API
///
/// ## Basic Usage
/// ```swift
/// // GET request
/// let user: User = try await EagleNet.get(
///     url: "https://api.example.com/users/1"
/// )
///
/// // POST request
/// let newUser = CreateUser(name: "Anbalagan D", email: "anbu94p@gmail.com")
/// let response: UserResponse = try await EagleNet.post(
///     url: "https://api.example.com/users",
///     body: newUser
/// )
///
/// // File upload
/// let response: UploadResponse = try await EagleNet.upload(
///     url: "https://api.example.com/upload",
///     parameters: [
///         .file(
///             key: "avatar",
///             fileName: "profile.jpg",
///             data: imageData,
///             mimeType: .jpegImage
///         ),
///         .text(key: "username", value: "Anbu")
///     ],
///     progress: { bytesTransferred, totalBytes in
///         let progress = Float(bytesTransferred) / Float(totalBytes)
///         print("Upload progress: \(Int(progress * 100))%")
///     }
/// )
/// ```
public enum EagleNet {
    /// The underlying network service that handles all requests
    static let networkService: NetworkService = NetworkServiceImpl()
}
