//
//  MockLocationsRepository.swift
//  Places
//
//  Created by Patrick Noordermeer on 27/01/2025.
//


import Foundation
import CoreLocation
@testable import Places

class MockLocationsRepository: LocationsRepository {
    var shouldReturnError = false

    func getLocations() async throws -> [Location] {
        if shouldReturnError {
            throw NSError(domain: "TestError", code: 1, userInfo: nil)
        }
        return [Location(id: UUID(), name: "Test Location", location: CLLocation(latitude: 0.0, longitude: 0.0), url: URL(string: "https://www.google.com"))]
    }
}

class MockCityCoordinateFinder: CityCoordinateFinder {
    var shouldReturnError = false
    var mockCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    func getCoordinateFrom(address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> ()) {
        DispatchQueue.global().async {
            if self.shouldReturnError {
                completion(nil, NSError(domain: "TestError", code: 2, userInfo: nil))
            } else {
                completion(self.mockCoordinate, nil)
            }
        }
    }
}

class MockURLOpener: URLOpener {
    var canOpen: Bool = true

    func canOpenURL(_ url: URL) async -> Bool {
        return canOpen
    }

    func open(_ url: URL) async {
        // Simulate opening URL
    }
}

class MockURLGenerator: URLGenerator {
    func createURL(for coordinate: CLLocationCoordinate2D) -> URL? {
        URL(string: "wikipedia://places?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)")
    }
}
