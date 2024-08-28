//
//  BodyConvertible.swift
//  EagleNet
//
//  Created by Anbalagan on 18/08/24.
//

import Foundation

public protocol BodyConvertible: Encodable, Sendable {
    func asBody(encoder: JSONEncoder) throws -> Data
}

extension BodyConvertible where Self == Data {
    public func asBody(encoder: JSONEncoder = .init()) throws -> Data {
        return self
    }
}

extension Data: BodyConvertible { }

extension BodyConvertible {
    func asBody(encoder: JSONEncoder = .init()) throws -> Data {
        try encoder.encode(self)
    }
}

extension Encodable where Self: Sendable {
    func asBodyConvertible() -> BodyConvertible {
        AnyBodyConvertible(body: self)
    }
}

struct AnyBodyConvertible<T>: BodyConvertible where T: Encodable, T: Sendable {
    let body: T

    func asBody(encoder: JSONEncoder) throws -> Data {
        try encoder.encode(body)
    }
}
