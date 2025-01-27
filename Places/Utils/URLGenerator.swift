import Foundation
import CoreLocation

protocol URLGenerator {
    func createURL(for location: CLLocationCoordinate2D) -> URL?
}

struct DefaultURLGenerator: URLGenerator {
    func createURL(for coordinate: CLLocationCoordinate2D) -> URL? {
        URL(string: "wikipedia://places?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)")
    }
}
