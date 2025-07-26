# Error Handling

⚠️ Handle network errors gracefully.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Overview

EagleNet provides comprehensive error handling to help you manage network failures and unexpected responses.

## Basic Error Handling

```swift
do {
    let user: User = try await EagleNet.get(
        url: "https://api.example.com/users/1"
    )
    // Handle success
} catch {
    // Handle any error
    print("Request failed: \(error)")
}
```

## Specific Error Types

```swift
do {
    let user: User = try await EagleNet.get(
        url: "https://api.example.com/users/1"
    )
} catch NetworkError.invalidURL {
    print("Invalid URL provided")
} catch NetworkError.noData {
    print("No data received from server")
} catch NetworkError.decodingError(let error) {
    print("Failed to decode response: \(error)")
} catch {
    print("Unexpected error: \(error)")
}
```

## HTTP Status Code Handling

```swift
do {
    let user: User = try await EagleNet.get(
        url: "https://api.example.com/users/1"
    )
} catch NetworkError.httpError(let statusCode, let data) {
    switch statusCode {
    case 401:
        print("Unauthorized - check your credentials")
    case 404:
        print("User not found")
    case 500...599:
        print("Server error: \(statusCode)")
    default:
        print("HTTP error: \(statusCode)")
    }
}
```

## Custom Error Handling

```swift
func handleNetworkError(_ error: Error) {
    if let networkError = error as? NetworkError {
        switch networkError {
        case .invalidURL:
            showAlert("Invalid URL")
        case .noData:
            showAlert("No data received")
        case .httpError(let code, _):
            showAlert("HTTP Error: \(code)")
        case .decodingError:
            showAlert("Failed to parse response")
        }
    } else {
        showAlert("Network request failed")
    }
}
```