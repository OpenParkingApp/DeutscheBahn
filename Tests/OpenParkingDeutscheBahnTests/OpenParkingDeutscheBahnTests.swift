import XCTest
import OpenParkingDeutscheBahn

final class OpenParkingDeutscheBahnTests: XCTestCase {
    func testExample() throws {
        guard let token = ProcessInfo.processInfo.environment["DB_TOKEN"] else {
            XCTFail("No access token found in environment")
            return
        }

        let data = try DeutscheBahn(accessToken: token).data()
        XCTAssert(!data.lots.isEmpty)
        for lot in data.lots {
            print(lot)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
