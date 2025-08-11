//
//  EagleNetActor.swift
//  EagleNet
//
//  Created by Anbalagan on 09/08/25.
//

/// Internal actor for EagleNet thread safety
///
/// - Warning: This actor is public for compiler requirements but should not be used directly.
///   Use EagleNet's public API methods instead.
@globalActor
public actor EagleNetActor {
    public static let shared = EagleNetActor()
}
