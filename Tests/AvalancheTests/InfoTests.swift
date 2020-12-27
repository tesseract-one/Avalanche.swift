//
//  File.swift
//  
//
//  Created by Daniel Leping on 23/12/2020.
//

import XCTest
@testable import Avalanche
    
final class InfoTests: XCTestCase {
    let keychain = MockKeychainFactory()
    var ava:Avalanche!
        
    override func setUp() {
        ava = Avalanche(url: URL(string: "https://api.avax-test.network")!, keychains: keychain, network: .test)
    }
        
    func testGetBlockchainID() {
        let success = expectation(description: "success")
        
        ava.info.getBlockchainID(alias: "X") { result in
            XCTAssertFalse(try! result.get().isEmpty)
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNetworkID() {
        let success = expectation(description: "success")
        
        ava.info.getNetworkID { result in
            XCTAssertEqual(self.ava.network.networkId, try! result.get())
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNetworkName() {
        let success = expectation(description: "success")
        
        ava.info.getNetworkName { result in
            XCTAssertEqual("fuji", try! result.get())
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNodeID() {
        let success = expectation(description: "success")
        
        ava.info.getNodeID { result in
            let id = try! result.get()
            XCTAssert(id.starts(with: "NodeID-"))
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNodeIP() {
        let success = expectation(description: "success")
        
        ava.info.getNodeIP { result in
            let ip = try! result.get()
            XCTAssertLessThan(0, ip.split(separator: ".").count)
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNodeVersion() {
        let success = expectation(description: "success")
        
        ava.info.getNodeVersion { result in
            let version = try! result.get()
            XCTAssertFalse(version.isEmpty)
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testIsBootstrapped() {
        let success = expectation(description: "success")
        
        ava.info.isBootstrapped(chain: "X") { result in
            XCTAssertTrue(try! result.get())
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPeers() {
        let success = expectation(description: "success")
        
        ava.info.peers { result in
            let peers = try! result.get()
            XCTAssertGreaterThan(peers.count, 0)
            XCTAssertLessThan(0, peers[0].ip.split(separator: ".").count)
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testTxFee() {
        let success = expectation(description: "success")
        
        ava.info.getTxFee { result in
            let txFee = try! result.get()
            XCTAssertGreaterThan(txFee.creationTxFee, 0)
            XCTAssertGreaterThan(txFee.txFee, 0)
            success.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    

    static var allTests = [
        ("testGetBlockchainID", testGetBlockchainID),
    ]
}
