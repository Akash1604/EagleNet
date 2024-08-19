//
//  NetworkService.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

public protocol NetworkService: Sendable {
    init(
        urlSession: URLSession,
        jsonEncoder: JSONEncoder,
        jsonDecoder: JSONDecoder
    )
    
    func execute<Response: Decodable>(_ request: NetworkRequestable) async throws -> Response

    func addPreInterceptor(_ interceptor: PreInterceptor)
    func addPostInterceptor(_ interceptor: PostInterceptor)
}

final class NetworkServiceImpl: NetworkService, @unchecked Sendable {
    private let urlSession: URLSession
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    private var preInterceptors = [PreInterceptor]()
    private var postInterceptors = [PostInterceptor]()
    
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
        
        urlRequest = try await preInterceptors.reduce(urlRequest) { result, interceptor in
            try await interceptor.modify(request: result)
        }
        
        let result = try await urlSession.data(for: urlRequest)
        
        let (data, urlResponse) = try await postInterceptors.reduce(result) { result, interceptor in
            try await interceptor.modify(data: result.0, urlResponse: result.1)
        }
        
        if let httpURLResponse = urlResponse as? HTTPURLResponse,
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
    
    func addPreInterceptor(_ interceptor: PreInterceptor) {
        preInterceptors.append(interceptor)
    }
    
    func addPostInterceptor(_ interceptor: PostInterceptor) {
        postInterceptors.append(interceptor)
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
}
