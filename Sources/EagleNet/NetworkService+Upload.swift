//
//  NetworkService+Upload.swift
//  EagleNet
//
//  Created by Anbalagan on 07/01/25.
//

extension NetworkService {
    public func upload<Response: Decodable>(
        url: URLConvertible,
        path: String? = nil,
        headers: [String: String]? = nil,
        queryParameters: [String: String]? = nil,
        parameters: [MultipartParameter] = [],
        progress: ProgressHandler? = nil
    ) async throws -> Response {
        var request = MultipartRequest(
            url: url,
            path: path,
            httpMethod: .post,
            headers: headers,
            parameters: queryParameters
        )

        for parameter in parameters {
            switch parameter {
            case .file(let key, let fileName, let data, let mimeType):
                request.addBodyParameter(
                    key: key,
                    value: data,
                    fileName: fileName,
                    contentType: mimeType
                )
            case .text(let key, let value):
                request.addBodyParameter(
                    key: key,
                    value: value
                )
            }
        }

        return try await upload(request, progress: progress)
    }
}
