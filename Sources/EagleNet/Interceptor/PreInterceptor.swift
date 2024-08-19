//
//  PreInterceptor.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

public protocol PreInterceptor: Sendable {
    func modify(request: URLRequest) async throws -> URLRequest
}
