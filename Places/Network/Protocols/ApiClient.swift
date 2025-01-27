import Foundation

enum ApiClientError: Error {
    case malformedURL
    case networkError
}

protocol ApiClient: Sendable {
    func get(path: String) async throws -> Data
}
