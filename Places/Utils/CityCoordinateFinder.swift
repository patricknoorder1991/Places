import CoreLocation

protocol CityCoordinateFinder {
    func getCoordinateFrom(address: String,completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ())
}

final class DefaultCityCoordinateFinder: CityCoordinateFinder {
    func getCoordinateFrom(
        address: String,
        completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> ()
    ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}
