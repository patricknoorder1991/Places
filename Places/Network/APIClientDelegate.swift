import Foundation

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
