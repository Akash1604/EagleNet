//
//  NetworkService.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

/// A protocol that defines the core networking capabilities for making HTTP requests.
///
/// NetworkService provides a centralized way to handle network requests with support for:
/// - Async/await based networking
/// - Request/Response interceptors
/// - File uploads with progress tracking
/// - JSON encoding/decoding
///
/// Example usage:
/// ```swift
/// let service = NetworkServiceImpl(
///     urlSession: .shared,
///     jsonEncoder: JSONEncoder(),
///     jsonDecoder: JSONDecoder()
/// )
///
/// // Add interceptors if needed
/// service.addRequestInterceptor(AuthInterceptor(token: "token123"))
///
/// // Make network requests
/// let response: User = try await service.execute(userRequest)
/// ```
public protocol NetworkService: Sendable {
    /// Creates a new network service instance
    /// - Parameters:
    ///   - urlSession: URLSession instance for making network requests
    ///   - jsonEncoder: Encoder for request body serialization
    ///   - jsonDecoder: Decoder for response deserialization
    init(
        urlSession: URLSession,
        jsonEncoder: JSONEncoder,
        jsonDecoder: JSONDecoder
    )

    /// Executes a network request and returns the decoded response
    /// - Parameter request: The request to execute
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the request fails or response cannot be decoded
    func execute<Response: Decodable>(_ request: NetworkRequestable) async throws -> Response

    /// Uploads data with progress tracking
    /// - Parameters:
    ///   - request: The upload request to execute
    ///   - progress: Optional closure to track upload progress
    /// - Returns: Decoded response of type `Response`
    /// - Throws: NetworkError if the upload fails or response cannot be decoded
    func upload<Response: Decodable>(
        _ request: NetworkRequestable,
        progress: ProgressHandler?
    ) async throws -> Response

    /// Adds an interceptor to modify requests before they are sent
    /// - Parameter interceptor: The request interceptor to add
    func addRequestInterceptor(_ interceptor: RequestInterceptor)

    /// Adds an interceptor to modify responses before they are decoded
    /// - Parameter interceptor: The response interceptor to add
    func addResponseInterceptor(_ interceptor: ResponseInterceptor)
}

final class NetworkServiceImpl: NetworkService, @unchecked Sendable {
    private let urlSession: URLSession
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    private var requestInterceptor = [RequestInterceptor]()
    private var responseInterceptors = [ResponseInterceptor]()

    required init(
        urlSession: URLSession = .shared,
        jsonEncoder: JSONEncoder = .init(),
        jsonDecoder: JSONDecoder = .init()
    ) {
        self.urlSession = urlSession
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
    }

    func execute<Response: Decodable>(_ request: NetworkRequestable) async throws -> Response {
        var urlRequest = try buildRequest(from: request)

        urlRequest = try await requestInterceptor.reduce(urlRequest) { result, interceptor in
            try await interceptor.modify(request: result)
        }

        let result = try await urlSession.data(for: urlRequest)

        let (data, urlResponse) = try await responseInterceptors.reduce(result) { result, interceptor in
            try await interceptor.modify(data: result.0, urlResponse: result.1)
        }

        return try handleResponse(data: data, response: urlResponse)
    }
    
    func upload<Response: Decodable>(
        _ request: NetworkRequestable,
        progress: ProgressHandler? = nil
    ) async throws -> Response {
        var urlRequest = try buildRequest(from: request)

        urlRequest = try await requestInterceptor.reduce(urlRequest) { result, interceptor in
            try await interceptor.modify(request: result)
        }

        let bodyData = urlRequest.httpBody ?? Data()
        urlRequest.httpBody = nil
        let result = try await urlSession.upload(
            for: urlRequest,
            from: bodyData,
            delegate: SessionDelegate(progress: progress)
        )

        let (data, urlResponse) = try await responseInterceptors.reduce(result) { result, interceptor in
            try await interceptor.modify(data: result.0, urlResponse: result.1)
        }

        return try handleResponse(data: data, response: urlResponse)
    }

    func addRequestInterceptor(_ interceptor: RequestInterceptor) {
        requestInterceptor.append(interceptor)
    }

    func addResponseInterceptor(_ interceptor: ResponseInterceptor) {
        responseInterceptors.append(interceptor)
    }
    
    private func buildRequest(
        from request: NetworkRequestable
    ) throws -> URLRequest {
        let url = try getRequestURL(request)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue

        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue(
                request.contentType.rawValue,
                forHTTPHeaderField: "Content-Type"
            )
        }
        
        if let bodyValue = request.body {
            urlRequest.httpBody = try bodyValue.asBody(encoder: jsonEncoder)
        }
        
        return urlRequest
    }

    private func getRequestURL(_ request: NetworkRequestable) throws -> URL {
        let url = try request.url.asURL()

        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }

        if let path = request.path {
            urlComponents.path += path
        }

        let queryItems: [URLQueryItem] = request.parameters?.map {
            .init(name: $0.key, value: $0.value)
        } ?? []
        
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems

        guard let constructedURL = urlComponents.url else {
            throw NetworkError.invalidURL
        }

        return constructedURL
    }
    
    private func handleResponse<Response: Decodable>(
        data: Data,
        response: URLResponse
    ) throws -> Response {
        if let httpURLResponse = response as? HTTPURLResponse,
              !httpURLResponse.isSuccess {
            throw NetworkError.failure(
                message: httpURLResponse.description,
                statusCode: httpURLResponse.statusCode,
                data: data
            )
        }

        do {
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
            let rawString = String(data: data, encoding: .utf8) ?? ""
            throw NetworkError.parsingError(error: error, raw: rawString)
        }
    }
}
