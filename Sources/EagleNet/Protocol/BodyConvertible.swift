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

extension Encodable {
    func asBodyConvertible() -> BodyConvertible {
        AnyBodyConvertible(body: self)
    }
}

struct AnyBodyConvertible<T>: BodyConvertible, @unchecked Sendable where T: Encodable {
    let body: T

    func asBody(encoder: JSONEncoder) throws -> Data {
        try encoder.encode(body)
    }
}
