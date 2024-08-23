//
//  DataExtension.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation

public extension Data {
    /// Convenience function to append a string to Data using .utf8 encoding.
    /// - Parameter string: The string to be converted and appended.
    mutating func append(_ string: String) {
        self += Data(string.utf8)
    }
}
