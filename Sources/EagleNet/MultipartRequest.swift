//
//  MultipartRequest.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation

public struct MultipartRequest: NetworkRequestable {
    public let url: String
    public let path: String?
    public let httpMethod: HTTPMethod
    public private(set) var headers: [String: String]?
    public private(set) var parameters: [String: String]?

    private var data = Data()
    public var body: (any BodyConvertible)? {
        if data.isEmpty { return nil }

        var finalData = data
        finalData.append("--\(boundary)--")
        return finalData
    }
    
    public var contentType: ContentType {
        .init("\(ContentType.multipartFormData); boundary=\(boundary)")
    }
    
    public let boundary = "Boundary-\(UUID().uuidString)"
    private let separator = "\r\n"
    private let contentDisposition = "Content-Disposition: form-data; name="
    
    public init(
        url: String,
        path: String? = nil,
        httpMethod: HTTPMethod = .post,
        headers: [String : String]? = nil,
        parameters: [String : String]? = nil
    ) {
        self.url = url
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.parameters = parameters
    }
    
    mutating func addHeader(key: String, value: String) {
        if (headers == nil) {
            headers = [:]
        }
        
        headers?[key] = value
    }
    
    mutating func addHeader(
        contentOf contents: [String: String]
    ) {
        if (headers == nil) {
            headers = contents
        } else {
            for (key, value) in contents {
                headers?[key] = value
            }
        }
    }
    
    mutating func addParameter(key: String, value: String) {
        if (parameters == nil) {
            parameters = [:]
        }
        
        parameters?[key] = value
    }
    
    mutating func addParameter(
        contentOf contents: [String: String]
    ) {
        if (parameters == nil) {
            parameters = contents
        } else {
            for (key, value) in contents {
                parameters?[key] = value
            }
        }
    }
    
    public mutating func addBodyParameter(
        key: String,
        value: Data,
        fileName: String? = nil,
        contentType: ContentType = .textPlain
    ) throws {
        data.append("--\(boundary)\(separator)")
        data.append("\(contentDisposition)\"\(key)\"")
        if let fileName {
            data.append("; filename=\"\(fileName)\"")
        }
        data.append(separator)
        data.append("Content-Type: \(contentType.rawValue)")
        data.append("\(separator)\(separator)")
        data.append(value)
        data.append(separator)
    }
    
    public mutating func addBodyParameters(
        contentOf parameters: [String: String]
    ) throws {
        for (key, value) in parameters {
            try addBodyParameter(key: key, value: Data(value.utf8))
        }
    }
}
