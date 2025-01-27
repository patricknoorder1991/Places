import MapKit

@MainActor
struct DefaultLocationsRepository: LocationsRepository {
    private let apiClient: ApiClient
    
    init(with apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func getLocations() async throws -> [Location] {
        let data = try await apiClient.get(path: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")
        let locations = try JSONDecoder().decode(LocationsResponse.self, from: data).locations
        
        return locations
    }
}

extension Location: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case lat
        case long
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        name = try? container.decode(String.self, forKey: .name)
        
        let lat = try container.decode(Double.self, forKey: .lat)
        let long = try container.decode(Double.self, forKey: .long)
        
        location = CLLocation(latitude: lat, longitude: long)
        url = URL(string: "wikipedia://places?lat=\(lat)&lon=\(long)")
    }
}

struct LocationsResponse: Decodable {
    let locations: [Location]
}
