//
//  DataRequest.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

public struct DataRequest: NetworkRequestable {
    public let url: String
    public let path: String?
    public let httpMethod: HTTPMethod
    public private(set) var headers: [String: String]?
    public private(set) var parameters: [String: String]?
    public private(set) var body: BodyConvertible?
    public var contentType: ContentType { .applicationJSON }

    public init(
        url: String,
        path: String? = nil,
        httpMethod: HTTPMethod = .get,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: BodyConvertible? = nil
    ) {
        self.url = url
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.parameters = parameters
        self.body = body
    }

    public init(
        url: String,
        path: String? = nil,
        httpMethod: HTTPMethod = .get,
        headers: [String: String]? = nil,
        parameters: [String: String]? = nil,
        body: (some Encodable & Sendable)? = nil
    ) {
        self.url = url
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.parameters = parameters
        self.body = body?.asBodyConvertible()
    }

    mutating func addHeader(key: String, value: String) {
        if headers == nil {
            headers = [:]
        }

        headers?[key] = value
    }

    mutating func addHeader(
        contentOf contents: [String: String]
    ) {
        if headers == nil {
            headers = contents
        } else {
            for (key, value) in contents {
                headers?[key] = value
            }
        }
    }

    mutating func addParameter(key: String, value: String) {
        if parameters == nil {
            parameters = [:]
        }

        parameters?[key] = value
    }

    mutating func addParameter(
        contentOf contents: [String: String]
    ) {
        if parameters == nil {
            parameters = contents
        } else {
            for (key, value) in contents {
                parameters?[key] = value
            }
        }
    }

    mutating func setBody(_ body: some BodyConvertible) {
        self.body = body
    }

    mutating func setBody(_ body: some Encodable & Sendable) {
        self.body = body.asBodyConvertible()
    }
}
