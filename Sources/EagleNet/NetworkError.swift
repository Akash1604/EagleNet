//
//  NetworkError.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

enum NetworkError: Error {
    case general(message: String, statusCode: Int)
    case parsingError(reason: String)
}
