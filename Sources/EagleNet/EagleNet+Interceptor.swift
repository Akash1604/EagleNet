//
//  EagleNet+Interceptor.swift
//  EagleNet
//
//  Created by Anbalagan on 16/07/25.
//

extension EagleNet {
    /// Adds an interceptor to modify requests before they are sent
    /// - Parameter interceptor: The request interceptor to add
    public static func addRequestInterceptor(_ interceptor: RequestInterceptor) {
        networkService.addRequestInterceptor(interceptor)
    }

    /// Adds an interceptor to modify responses before they are decoded
    /// - Parameter interceptor: The response interceptor to add
    public static func addResponseInterceptor(_ interceptor: ResponseInterceptor) {
        networkService.addResponseInterceptor(interceptor)
    }
}
