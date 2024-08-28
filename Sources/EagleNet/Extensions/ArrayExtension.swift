//
//  ArrayExtension.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation

extension Array {
    /// Async version of the `reduce` function.
    ///
    /// - Parameters:
    ///     - initialResult: The initial value for the reduction.
    ///     - nextPartialResult: An asynchronous closure that calculates the
    ///     next partial result based on the previous result and the current element.
    /// - Returns: The final result of the reduction, which is of the same type as `initialResult`.
    ///
    /// This function iterates over the elements of the sequence, applying the `nextPartialResult`
    /// closure to each element and the previous result to calculate the next partial result.
    /// The final result is returned after all elements have been processed.
    ///
    /// **Example:**
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// let sum = await numbers.reduce(0) { partialSum, number in
    ///     return partialSum + number
    /// }
    /// print(sum) // Output: 15
    /// ```
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
