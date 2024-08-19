//
//  ArrayExtension.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation

extension Array {
    @inlinable public func reduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: (Result, Element) async throws -> Result
    ) async rethrows -> Result {
        var result = initialResult
        for element in self {
            result = try await nextPartialResult(result, element)
        }
        return result
    }
}
