import Foundation

final class DefaultApiClient: ApiClient {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default, delegate: APIClientDelegate(), delegateQueue: nil)) {
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

final class APIClientDelegate: NSObject, URLSessionDelegate {
    // MARK: URLSessionDelegate
    // needed to bypass zScaler proxy SSL error on simulator
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        let authenticationMethod = challenge.protectionSpace.authenticationMethod
        if authenticationMethod == NSURLAuthenticationMethodServerTrust {
            var error: CFError?
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let isTrusted = SecTrustEvaluateWithError(serverTrust, &error)
                
                if isTrusted {
                    return (.performDefaultHandling, nil)
                }
                
                return (.useCredential, URLCredential(trust: serverTrust))
            }
        }
        
        return (.cancelAuthenticationChallenge, nil)
    }
}
