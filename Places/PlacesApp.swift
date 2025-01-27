import SwiftUI

@main
struct PlacesApp: App {
    var body: some Scene {
        WindowGroup {
            let urlGenerator: URLGenerator = DefaultURLGenerator()
            let urlOpener: URLOpener = DefaultURLOpener()
            let apiClient: ApiClient = DefaultApiClient(session:
                                                            URLSession(configuration: .default,
                                                                       delegate: APIClientDelegate(),
                                                                       delegateQueue: nil)
            )
            let cityCoordinatorFinder: CityCoordinateFinder = DefaultCityCoordinateFinder()
            let locationRepository: LocationsRepository = DefaultLocationsRepository(with: apiClient)

            ListView(
                repository: locationRepository,
                cityCoordinateFinder: cityCoordinatorFinder,
                urlOpener: urlOpener,
                urlGenerator: urlGenerator)
        }
    }
}
