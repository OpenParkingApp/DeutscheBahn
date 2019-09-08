import Foundation

struct Occupancies: Codable {
    let allocations: [Allocation]

    struct Allocation: Codable {
        let space: Space
        let allocation: Allocation

        struct Space: Codable {
            let id: Int
            let title: String
            let station: Station
            let name: String
            let nameDisplay: String

            struct Station: Codable {
                let id: Int
                let name: String
            }
        }

        struct Allocation: Codable {
            let validData: Bool
            let timestamp: String
            let capacity: Int
            let text: Text

            enum Text: String, Codable {
                case lte10 = "bis 10"
                case gt10 = "> 10"
                case gt30 = "> 30"
                case gt50 = "> 50"
            }
        }
    }
}
