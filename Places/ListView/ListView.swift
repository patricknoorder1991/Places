import SwiftUI

struct ListView: View {
    @StateObject private var viewModel: ListViewModel
    
    init(repository: any LocationsRepository,
         cityCoordinateFinder: CityCoordinateFinder,
         urlOpener: URLOpener,
         urlGenerator: URLGenerator) {
        _viewModel = StateObject(wrappedValue: ListViewModel(
            repository: repository,
            cityCoordinateFinder: cityCoordinateFinder,
            urlOpener: urlOpener,
            urlGenerator: urlGenerator)
        )
    }

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                loadingView
            case .success(let items):
                addressInputView
                listView(items: items)
            case .error(let error):
                errorView(error)
            }
        }
        .padding()
        .onSubmit(viewModel.handleAddressSubmit)
        .alert(isPresented: $viewModel.isErrorPresented, content: errorAlert)
        .task { await viewModel.fetchLocations() }
    }

    private var addressInputView: some View {
        TextField("Type a place or address.", text: $viewModel.address)
            .submitLabel(.done)
            .accessibilityLabel(Text("Type a place address"))
            .accessibilityAddTraits([.isSearchField])
    }

    private var loadingView: some View {
        ProgressView()
            .scaleEffect(.init(width: 2, height: 2))
    }

    private func listView(items: [Location]) -> some View {
        List {
            ForEach(items) { item in
                Link(item.name ?? "", destination: item.url!)
                    .accessibilityLabel(Text(item.name ?? "no name"))
                    .accessibilityAddTraits([.isButton])
                    .accessibilityHint(Text("Opens location on map in Wikipedia app (if installed)"))
            }
        }
        .accessibilityLabel(Text("Place names list"))
    }

    private func errorView(_ error: Error) -> some View {
        Text(error.localizedDescription.localizedLowercase)
    }

    private func errorAlert() -> Alert {
        Alert(
            title: Text("Ooops"),
            message: Text("Wikipedia App is not installed."),
            dismissButton: .default(Text("OK"))
        )
    }
}

