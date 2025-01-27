import XCTest
@testable import Places

class ListViewModelTests: XCTestCase {
    var viewModel: ListViewModel!
    var mockRepository: MockLocationsRepository!
    var mockCityCoordinateFinder: MockCityCoordinateFinder!
    var mockURLOpener: MockURLOpener!
    var mockURLGenerator: MockURLGenerator!

    override func setUp() {
        super.setUp()
        mockRepository = MockLocationsRepository()
        mockCityCoordinateFinder = MockCityCoordinateFinder()
        mockURLOpener = MockURLOpener()
        mockURLGenerator = MockURLGenerator()
        viewModel = ListViewModel(repository: mockRepository,
                                  cityCoordinateFinder: mockCityCoordinateFinder,
                                  urlOpener: mockURLOpener,
                                  urlGenerator: mockURLGenerator)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        mockCityCoordinateFinder = nil
        mockURLOpener = nil
        mockURLGenerator = nil
        
        super.tearDown()
    }

    func testFetchLocationsSuccess() async {
        await viewModel.fetchLocations()
        switch viewModel.viewState {
        case .success(let items):
            XCTAssertEqual(items.count, 1)
            XCTAssertEqual(items.first?.name, "Test Location")
        default:
            XCTFail("Expected success state with one item")
        }
    }

    func testFetchLocationsError() async {
        mockRepository.shouldReturnError = true
        await viewModel.fetchLocations()
        switch viewModel.viewState {
        case .error:
            XCTAssertTrue(true) // Pass if error state is reached
        default:
            XCTFail("Expected error state")
        }
    }
}
