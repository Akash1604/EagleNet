# Usage Examples

📚 Real-world examples of using EagleNet.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Complete User Management Example

```swift
import EagleNet

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

struct CreateUserRequest: Encodable {
    let name: String
    let email: String
}

class UserService {
    
    init() {
        // Setup authentication
        EagleNet.addRequestInterceptor(
            AuthInterceptor(token: "your-auth-token")
        )
        
        // Setup logging
        EagleNet.addResponseInterceptor(LoggingInterceptor())
    }
    
    func getUser(id: Int) async throws -> User {
        return try await EagleNet.get(
            url: "https://api.example.com/users/\(id)"
        )
    }
    
    func createUser(name: String, email: String) async throws -> User {
        let request = CreateUserRequest(name: name, email: email)
        return try await EagleNet.post(
            url: "https://api.example.com/users",
            body: request
        )
    }
    
    func updateUser(_ user: User) async throws -> User {
        return try await EagleNet.put(
            url: "https://api.example.com/users/\(user.id)",
            body: user
        )
    }
    
    func deleteUser(id: Int) async throws {
        try await EagleNet.delete(
            url: "https://api.example.com/users/\(id)"
        )
    }
}
```

## File Upload with Progress

```swift
import SwiftUI
import EagleNet

struct FileUploadView: View {
    @State private var uploadProgress: Float = 0
    @State private var isUploading = false
    
    var body: some View {
        VStack {
            if isUploading {
                ProgressView(value: uploadProgress)
                    .progressViewStyle(LinearProgressViewStyle())
                Text("\(Int(uploadProgress * 100))% uploaded")
            }
            
            Button("Upload Image") {
                uploadImage()
            }
            .disabled(isUploading)
        }
    }
    
    private func uploadImage() {
        guard let imageData = UIImage(named: "sample")?.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        isUploading = true
        
        Task {
            do {
                let response: UploadResponse = try await EagleNet.upload(
                    url: "https://api.example.com/upload",
                    parameters: [
                        .file(
                            key: "image",
                            fileName: "photo.jpg",
                            data: imageData,
                            mimeType: .jpegImage
                        )
                    ],
                    progress: { bytesTransferred, totalBytes in
                        DispatchQueue.main.async {
                            self.uploadProgress = Float(bytesTransferred) / Float(totalBytes)
                        }
                    }
                )
                
                print("Upload successful: \(response)")
            } catch {
                print("Upload failed: \(error)")
            }
            
            DispatchQueue.main.async {
                self.isUploading = false
                self.uploadProgress = 0
            }
        }
    }
}
```

## API Client with Error Handling

```swift
class APIClient {
    private let baseURL = "https://api.example.com"
    
    init() {
        setupInterceptors()
    }
    
    private func setupInterceptors() {
        EagleNet.addRequestInterceptor(AuthInterceptor(token: getAuthToken()))
        EagleNet.addResponseInterceptor(ErrorLoggingInterceptor())
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Encodable? = nil
    ) async throws -> T {
        let url = "\(baseURL)\(endpoint)"
        
        do {
            switch method {
            case .GET:
                return try await EagleNet.get(url: url)
            case .POST:
                return try await EagleNet.post(url: url, body: body)
            case .PUT:
                return try await EagleNet.put(url: url, body: body)
            case .DELETE:
                try await EagleNet.delete(url: url)
                return EmptyResponse() as! T
            }
        } catch NetworkError.httpError(let statusCode, let data) {
            throw APIError.httpError(statusCode, data)
        } catch NetworkError.decodingError(let error) {
            throw APIError.decodingError(error)
        } catch {
            throw APIError.networkError(error)
        }
    }
}
```