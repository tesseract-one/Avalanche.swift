import XCTest
@testable import Avalanche


    
final class AvalancheTests: XCTestCase {
    func testExample() {
        
        let keychain = MockKeychainFactory()
        let ava = Avalanche(url: URL(string: "https://api.avax-test.network")!, keychains: keychain)
        
        let expect = expectation(description: "RPC Call should work")
        
        ava.health.getLiveness() { result in
            print("Result", result)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
