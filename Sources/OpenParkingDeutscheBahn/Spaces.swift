import Foundation

struct Spaces: Codable {
    let offset, limit, count, totalCount: Int
    let items: [Item]

    struct Item: Codable {
        let id: Int
        let title: String
        let station: Station
        let responsibility: String
        let source: String
        let name: String
        let nameDisplay: String
        let spaceType: SpaceType
        let geoLocation: GeoLocation
        let url: String
        let `operator`: String
        let operatorUrl: URL?
        let address: Address
        let facilityType: String // keine, Parkscheinautomat, Schrankenanlage
        let openingHours: String?
        let numberParkingPlaces: String
        let numberHandicapedPlaces: String?
        let hasHandicapedPlaces: Bool
        let isOutOfService: Bool
        let hasReservation: Bool
        let hasPrognosis: Bool
        let hasChargingStation: Bool
        let spaceInfo: SpaceInfo
        let tariffPrices: [TariffPrice]

        struct Station: Codable {
            let id: Int
            let name: String
        }

        enum SpaceType: String, Codable {
            case deck = "Parkdeck"
            case structure = "Parkhaus"
            case lot = "Parkplatz"
            case street = "Straße"
            case underground = "Tiefgarage"
        }

        struct GeoLocation: Codable {
            let longitude: Double
            let latitude: Double
        }

        struct Address: Codable {
            let cityName: String
            let postalCode: String
            let street: String
            let supplement: String?
        }

        struct SpaceInfo: Codable {
            let clearanceWidth: String?
            let allowedPropulsions: String? // alle
            let chargingStation: String?
            let clearanceHeight: String?
            let locationNightAccess: String?
        }

        struct TariffPrice: Codable {
            let id: Int
            let duration: Duration
            let price: Double?

            enum Duration: String, Codable {
                case the1Day = "1day"
                case the1DayDiscount = "1dayDiscount"
                case the1Hour = "1hour"
                case the1MonthLongTerm = "1monthLongTerm"
                case the1MonthReservation = "1monthReservation"
                case the1MonthVendingMachine = "1monthVendingMachine"
                case the1Week = "1week"
                case the1WeekDiscount = "1weekDiscount"
                case the20Min = "20min"
                case the30Min = "30min"
            }
        }
    }
}
