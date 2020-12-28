//
//  IPCTests.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import XCTest
@testable import Avalanche

final class IPCTests: AvalancheTestCase {
    func testPublishBlockchain() {
        let expectation = self.expectation(description: "ipcs.publishBlockchain")
        
        let ava = self.ava!
        
        ava.info.getBlockchainID(alias: "X") { response in
            let id = try! response.get()
            ava.ipc.publishBlockchain(blockchainID: id) { response in
                let urls = try! response.get()
                
                XCTAssertFalse(urls.consensusURL.isEmpty)
                XCTAssertFalse(urls.decisionsURL.isEmpty)
                
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUnpublishBlockchain() {
        let expectation = self.expectation(description: "ipcs.unpublishBlockchain")
        
        let ava = self.ava!
        
        ava.info.getBlockchainID(alias: "X") { response in
            let id = try! response.get()
            ava.ipc.unpublishBlockchain(blockchainID: id) { response in
                XCTAssertEqual(try! response.get(), .nil)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}

