import CoreLocation
import Foundation

struct Location: Identifiable {
    let id: UUID
    
    let name: String?
    let location: CLLocation
    
    let url: URL?
}
