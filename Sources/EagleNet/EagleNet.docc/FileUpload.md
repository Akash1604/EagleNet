# File Upload

📁 Upload files using multipart/form-data.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Basic File Upload

```swift
let imageData = // ... your image data ...

struct UploadResponse: Decodable {
    let url: String
    let id: String
}

let response: UploadResponse = try await EagleNet.upload(
    url: "https://api.example.com/upload",
    parameters: [
        .file(
            key: "avatar",
            fileName: "profile.jpg",
            data: imageData,
            mimeType: .jpegImage
        ),
        .text(key: "username", value: "Anbu")
    ]
)
```

## Upload with Progress Tracking

Monitor upload progress in real-time:

```swift
let response: UploadResponse = try await EagleNet.upload(
    url: "https://api.example.com/upload",
    parameters: [
        .file(
            key: "document",
            fileName: "report.pdf",
            data: documentData,
            mimeType: .pdf
        )
    ],
    progress: { bytesTransferred, totalBytes in
        let progress = Float(bytesTransferred) / Float(totalBytes)
        print("Upload progress: \(Int(progress * 100))%")
        
        DispatchQueue.main.async {
            // Update UI progress indicator
        }
    }
)
```

## Multiple Files

Upload multiple files in a single request:

```swift
let response: UploadResponse = try await EagleNet.upload(
    url: "https://api.example.com/upload",
    parameters: [
        .file(key: "image1", fileName: "photo1.jpg", data: image1Data, mimeType: .jpegImage),
        .file(key: "image2", fileName: "photo2.jpg", data: image2Data, mimeType: .jpegImage),
        .text(key: "album", value: "Vacation Photos")
    ]
)
```