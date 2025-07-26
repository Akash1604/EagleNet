# Request Interceptors

🔍 Modify requests before they are sent.

@Metadata {
   @PageImage(purpose: icon, source: "EagleNet")
}

## Overview

Request interceptors allow you to modify outgoing requests, such as adding authentication headers, logging, or request transformation.

## Creating a Request Interceptor

Implement the `RequestInterceptor` protocol:

```swift
struct AuthInterceptor: RequestInterceptor {
    let token: String
    
    func modify(request: URLRequest) async throws -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return modifiedRequest
    }
}
```

## Adding Interceptors

Register your interceptor with EagleNet:

```swift
EagleNet.addRequestInterceptor(
    AuthInterceptor(token: "your-auth-token")
)
```

## Common Use Cases

### Authentication

```swift
struct AuthInterceptor: RequestInterceptor {
    let token: String
    
    func modify(request: URLRequest) async throws -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return modifiedRequest
    }
}
```

### API Key

```swift
struct APIKeyInterceptor: RequestInterceptor {
    let apiKey: String
    
    func modify(request: URLRequest) async throws -> URLRequest {
        var modifiedRequest = request
        modifiedRequest.addValue(apiKey, forHTTPHeaderField: "X-API-Key")
        return modifiedRequest
    }
}
```

### Request Logging

```swift
struct RequestLoggingInterceptor: RequestInterceptor {
    func modify(request: URLRequest) async throws -> URLRequest {
        print("🚀 Request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
        return request
    }
}
```