import XCTest
import OpenParkingTests
import OpenParkingDeutscheBahn

final class OpenParkingDeutscheBahnTests: XCTestCase {
    func testDatasource() throws {
        guard let token = ProcessInfo.processInfo.environment["DB_TOKEN"] else {
            XCTFail("No access token found in environment")
            return
        }
        assert(datasource: DeutscheBahn(accessToken: token),
               ignoreDataAge: true) // Unfortunately data ages can't be trusted with this dataset.
    }
}
