import Foundation

struct Occupancies: Decodable {
    let allocations: [Allocation]

    struct Allocation: Decodable {
        let space: Space
        let allocation: Allocation

        struct Space: Decodable {
            let id: Int
            let title: String
            let station: Station
            let name: String
            let nameDisplay: String

            struct Station: Decodable {
                let id: Int
                let name: String
            }
        }

        struct Allocation: Decodable {
            let validData: Bool
            let timestamp: String
            let capacity: Int
            let text: Text?

            private enum CodingKeys: CodingKey {
                case validData, timestamp, capacity, text
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.validData = try container.decode(Bool.self, forKey: .validData)
                guard self.validData else {
                    // FIXME: This is dummy data and definitely not a good way of handling this.
                    self.timestamp = ""
                    self.capacity = 0
                    self.text = .lte10
                    return
                }
                self.timestamp = try container.decode(String.self, forKey: .timestamp)
                self.capacity = try container.decode(Int.self, forKey: .capacity)
                self.text = try container.decodeIfPresent(Text.self, forKey: .text)
            }

            enum Text: String, Decodable {
                case lte10 = "bis 10"
                case gt10 = "> 10"
                case gt30 = "> 30"
                case gt50 = "> 50"
            }
        }
    }
}
