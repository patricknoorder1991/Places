import Foundation

final class DefaultApiClient: ApiClient {
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(path: String) async throws -> Data {
        guard let url = URL(string: path) else {
            throw ApiClientError.malformedURL
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, _) = try await session.data(for: request)
            return data
        } catch {
            throw ApiClientError.networkError
        }
    }
}
