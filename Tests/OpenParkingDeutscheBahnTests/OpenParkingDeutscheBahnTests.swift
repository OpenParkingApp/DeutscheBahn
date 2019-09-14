import XCTest
import OpenParkingTests
import OpenParkingDeutscheBahn

final class OpenParkingDeutscheBahnTests: XCTestCase {
    func testDatasource() throws {
        guard let token = ProcessInfo.processInfo.environment["DB_TOKEN"] else {
            XCTFail("No access token found in environment")
            return
        }
        assert(datasource: DeutscheBahn(accessToken: token))
    }

    static var allTests = [
        ("testDatasource", testDatasource),
    ]
}
