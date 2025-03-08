//
//  NetworkService.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

/// Centeralize protocol to handle network requests.
public protocol NetworkService: Sendable {
    init(
        urlSession: URLSession,
        jsonEncoder: JSONEncoder,
        jsonDecoder: JSONDecoder
    )

    func execute<Response: Decodable>(_ request: NetworkRequestable) async throws -> Response

    func upload<Response: Decodable>(
        _ request: NetworkRequestable,
        progress: ProgressHandler?
    ) async throws -> Response

    func addRequestInterceptor(_ interceptor: RequestInterceptor)
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

        urlRequest.setValue(
            request.contentType.rawValue,
            forHTTPHeaderField: "Content-Type"
        )
        
        if let bodyValue = request.body {
            urlRequest.httpBody = try bodyValue.asBody(encoder: jsonEncoder)
        }
        
        return urlRequest
    }

    private func getRequestURL(_ request: NetworkRequestable) throws -> URL {
        let url = try request.url.asURL()

        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError.invalid
        }

        if let path = request.path {
            urlComponents.path += path
        }

        urlComponents.queryItems = request.parameters?.map {
            .init(name: $0.key, value: $0.value)
        }

        guard let constructedURL = urlComponents.url else {
            throw URLError.invalid
        }

        return constructedURL
    }
    
    private func handleResponse<Response: Decodable>(
        data: Data,
        response: URLResponse
    ) throws -> Response {
        if let httpURLResponse = response as? HTTPURLResponse,
              !httpURLResponse.isSuccess {
            throw NetworkError.general(
                message: httpURLResponse.description,
                statusCode: httpURLResponse.statusCode
            )
        }

        do {
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
            throw NetworkError.parsingError(reason: error.localizedDescription)
        }
    }
}
