//
//  URLConvertible.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

enum URLError: Error {
    case invalid
}

public protocol URLConvertible: Sendable {
    func asURL() throws -> URL
}

public extension URLConvertible where Self == String {
    func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw URLError.invalid
        }

        return url
    }
}

public extension URLConvertible where Self == URL {
    func asURL() throws -> URL { self }
}

extension String: URLConvertible { }

extension URL: URLConvertible { }
