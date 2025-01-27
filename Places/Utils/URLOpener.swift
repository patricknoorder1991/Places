import Foundation
import SwiftUI

protocol URLOpener: Sendable {
    func canOpenURL(_ url: URL) async -> Bool
    @MainActor func open(_ url: URL) async
}

final class DefaultURLOpener: URLOpener {
    func canOpenURL(_ url: URL) async -> Bool {
        await UIApplication.shared.canOpenURL(url)
    }

    @MainActor func open(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

