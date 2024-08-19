//
//  NetworkRequestable.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

public protocol NetworkRequestable: Sendable {
    var url: String { get }
    var path: String? { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
    var body: BodyConvertible? { get }
    var contentType: ContentType { get }
}
