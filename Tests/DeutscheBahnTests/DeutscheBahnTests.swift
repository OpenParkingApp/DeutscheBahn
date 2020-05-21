import XCTest
import DatasourceValidation
import DeutscheBahn

final class DeutscheBahnTests: XCTestCase {
    func testDatasource() throws {
        guard let token = ProcessInfo.processInfo.environment["DB_TOKEN"] else {
            XCTFail("No access token found in environment")
            return
        }
        validate(datasource: DeutscheBahn(accessToken: token),
                 ignoreDataAge: true) // Unfortunately data ages can't be trusted with this dataset.
    }
}
