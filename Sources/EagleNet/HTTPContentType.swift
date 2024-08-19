//
//  HTTPContentType.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation

public struct ContentType {
    let rawValue: String
    
    init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension ContentType: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        rawValue = value
    }
}

public extension ContentType {
    static let textPlain: ContentType = "text/plain"
    static let applicationJSON: ContentType = "application/json"
    static let multipartFormData: ContentType = "multipart/form-data"
    static let applicationOctetStream: ContentType = "application/octet-stream"
}
