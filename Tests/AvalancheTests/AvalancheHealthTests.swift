import XCTest
@testable import Avalanche


    
final class AvalancheHealthTests: XCTestCase {
    func testGetLiveness() {
        let keychain = MockKeychainFactory()
        let ava = Avalanche(url: URL(string: "https://api.avax-test.network")!, keychains: keychain, network: .test)
        
        let expect = expectation(description: "RPC Call should work")
        
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
