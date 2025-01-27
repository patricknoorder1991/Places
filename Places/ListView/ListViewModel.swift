import Foundation
import SwiftUI
import Combine

@MainActor
class ListViewModel: ObservableObject {
    enum ViewState {
        case loading
        case success(items: [Location])
        case error(error: Error)
    }

    @Published var viewState: ViewState = .loading
    @Published var address: String = ""
    @Published var isErrorPresented: Bool = false

    private let repository: LocationsRepository
    private let cityCoordinateFinder: CityCoordinateFinder
    private let urlOpener: URLOpener
    private let urlGenerator: URLGenerator

    init(repository: LocationsRepository,
         cityCoordinateFinder: CityCoordinateFinder,
         urlOpener: URLOpener,
         urlGenerator: URLGenerator) {
        self.repository = repository
        self.cityCoordinateFinder = cityCoordinateFinder
        self.urlOpener = urlOpener
        self.urlGenerator = urlGenerator
    }

    func fetchLocations() async {
        viewState = .loading
        do {
            let locations = try await repository.getLocations()
            viewState = .success(items: locations)
        } catch {
            viewState = .error(error: error)
        }
    }

    func handleAddressSubmit() {
        cityCoordinateFinder.getCoordinateFrom(address: address) { [weak self] coordinate, error in
            guard let self = self,
                    let coordinate = coordinate,
                    let placesUrl = URL(string: "wikipedia://places"),
                  error == nil else {
                return
            }
            
            Task {
                guard await self.urlOpener.canOpenURL(placesUrl),
                        let url = self.urlGenerator.createURL(for: coordinate) else {
                    self.isErrorPresented = true
                    return
                }

                await self.urlOpener.open(url)
            }
        }
    }
}
