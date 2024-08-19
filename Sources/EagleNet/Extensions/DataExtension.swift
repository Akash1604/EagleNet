//
//  DataExtension.swift
//  EagleNet
//
//  Created by Anbalagan on 19/08/24.
//

import Foundation

public extension Data {
    mutating func append(_ string: String) {
        self += Data(string.utf8)
    }
}
