//
//  File.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

import Foundation

public enum MultipartParameter {
    case file(
        key: String,
        fileName: String,
        data: Data,
        mimeType: ContentType
    )

    case text(key: String, value: String)
}
