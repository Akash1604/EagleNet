//
//  HTTPURLResponseExtension.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

extension HTTPURLResponse {
    var isSuccess: Bool { 200 ... 299 ~= statusCode }
}
