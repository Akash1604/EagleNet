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

protocol URLConvertible {
    func asURL() throws -> URL
}

extension URLConvertible where Self == String {
    func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw URLError.invalid
        }

        return url
    }
}

extension URLConvertible where Self == URL {
    func asURL() throws -> URL { self }
}

extension String: URLConvertible { }

extension URL: URLConvertible { }
