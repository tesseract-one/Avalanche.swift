//
//  File.swift
//  
//
//  Created by Daniel Leping on 23/12/2020.
//

import XCTest
@testable import Avalanche
    
final class AvalancheInfoTests: XCTestCase {
    let keychain = MockKeychainFactory()
    var ava:Avalanche!
        
    override func setUp() {
        ava = Avalanche(url: URL(string: "https://api.avax-test.network")!, keychains: keychain)
    }
        
    func testGetBlockchainID() {
        let success = expectation(description: "success")
        
        ava.info.getBlockchainID(alias: "X") { result in
            XCTAssertFalse(try! result.get().blockchainID.isEmpty)
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    static var allTests = [
        ("testGetBlockchainID", testGetBlockchainID),
    ]
}