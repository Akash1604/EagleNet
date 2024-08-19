//
//  PostInterceptor.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation

public protocol PostInterceptor: Sendable {
    func modify(
        data: Data,
        urlResponse: URLResponse
    ) async throws -> (Data, URLResponse)
}
