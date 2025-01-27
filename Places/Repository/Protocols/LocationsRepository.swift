protocol LocationsRepository: Sendable {
    func getLocations() async throws -> [Location]
}
