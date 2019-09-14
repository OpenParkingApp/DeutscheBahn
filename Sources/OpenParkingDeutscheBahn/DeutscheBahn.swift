import Foundation
import OpenParkingBase

public class DeutscheBahn: Datasource {
    public let name = "Deutsche Bahn"
    public let slug = "deutschebahn"

    public let infoUrl = URL(string: "https://data.deutschebahn.com/dataset/api-parkplatz")!

    let spacesURL = URL(string: "https://api.deutschebahn.com/bahnpark/v1/spaces")!
    let occupanciesURL = URL(string: "https://api.deutschebahn.com/bahnpark/v1/spaces/occupancies")!

    let accessToken: String

    var authHeader: [String: String] {
        return ["Authorization": "Bearer \(self.accessToken)"]
    }

    public init(accessToken: String) {
        self.accessToken = accessToken
    }

    public func data() throws -> DataPoint {
        let spaces = try getSpaces()
        let occupancies = try getOccupancies()

        // Spaces contain info on several hundred parking spaces tracked by the DB API, but only a small subset offer occupancy data.
        // By matching them with the results from the Occupancy API (which doesn't offer geodata), we combine the data to what we need here.

        var data: [(Spaces.Item, Occupancies.Allocation)] = []
        for allocation in occupancies.allocations {
            if let space = spaces.items.first(where: { $0.id == allocation.space.id }) {
                data.append((space, allocation))
            } else {
                print("No space found for \(allocation.space.name)")
            }
        }

        let lots = data.map { arg -> LotResult in
            let (item, allocation) = arg

            guard allocation.allocation.validData else {
                return .failure(.other(reason: "API reported data to be invalid, whatever that means."))
            }

            var available: ClosedRange<Int> = 0...1
            let capacity = allocation.allocation.capacity
            switch allocation.allocation.text {
            case .lte10:
                let upperBound = capacity < 10 ? capacity : 10
                available = 0...upperBound
            case .gt10:
                let upperBound = capacity < 30 ? capacity : 30
                available = 11...upperBound
            case .gt30:
                let upperBound = capacity < 50 ? capacity : 50
                available = 31...upperBound
            case .gt50:
                available = 51...allocation.allocation.capacity
            }

            var type: Lot.LotType = .lot
            switch item.spaceType {
            case .deck, .structure:
                type = .structure
            case .lot:
                type = .lot
            case .street:
                type = .street
            case .underground:
                type = .underground
            }

            return .success(Lot(dataAge: allocation.allocation.timestamp.date(withFormat: .isoNoTimezone),
                                name: item.name,
                                coordinates: Coordinates(lat: item.geoLocation.latitude, lng: item.geoLocation.longitude),
                                city: item.address.cityName,
                                region: nil,
                                address: item.address.street,
                                available: .range(available),
                                capacity: allocation.allocation.capacity,
                                state: .open,
                                type: type,
                                detailURL: URL(string: item.url),
                                additionalInformation: [
                                    "address_supplement": item.address.supplement as Any
                                ]))
        }

        return DataPoint(lots: lots)
    }

    func getSpaces() throws -> Spaces {
        let url = URL(string: spacesURL.absoluteString + "?limit=1000")!
        let (data, response) = try get(url: url, headers: authHeader)
        guard response.statusCode == 200 else {
            let resp = String(data: data, encoding: .utf8) ?? "n/a"
            throw OpenParkingError.server(status: response.statusCode, response: resp)
        }
        return try JSONDecoder().decode(Spaces.self, from: data)
    }

    func getOccupancies() throws -> Occupancies {
        let (data, response) = try get(url: occupanciesURL, headers: authHeader)
        guard response.statusCode == 200 else {
            let resp = String(data: data, encoding: .utf8) ?? "n/a"
            throw OpenParkingError.server(status: response.statusCode, response: resp)
        }
        return try JSONDecoder().decode(Occupancies.self, from: data)
    }
}
