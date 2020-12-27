import XCTest
@testable import Avalanche


    
final class HealthTests: AvalancheTestCase {
    func testGetLiveness() {
        let expect = expectation(description: "getLiveness")
        
        ava.health.getLiveness() { result in
            XCTAssertTrue(try! result.get().healthy)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }

    static var allTests = [
        ("testGetLiveness", testGetLiveness),
    ]
}
