//
//  File.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import XCTest
@testable import Avalanche

import RPC
    
final class AdminTests: AvalancheTestCase {
    func testAlias() {
        let expectation = self.expectation(description: "admin.alias")
        
        let alias = String("testAlias") + String(UInt64.random(in: 0..<UInt64.max))
        
        ava.admin.alias(alias: alias, endpoint: "health") { result in
            XCTAssertEqual(try! result.get(), .nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChainAlias() {
        let expectation = self.expectation(description: "admin.chainAlias")
        
        let ava = self.ava!
        
        ava.info.getBlockchainID(alias: "C") { result in
            let id = try! result.get()
            
            let alias = String("testChainAlias") + String(UInt64.random(in: 0..<UInt64.max))
            
            ava.admin.aliasChain(chain: id, alias: alias) { result in
                XCTAssertEqual(try! result.get(), .nil)
                expectation.fulfill()
            }
        }
        
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLockProfile() {
        let expectation = self.expectation(description: "admin.lockProfile")
        
        ava.admin.lockProfile { result in
            XCTAssertEqual(try! result.get(), .nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMemoryProfile() {
        let expectation = self.expectation(description: "admin.memoryProfile")
        
        ava.admin.memoryProfile { result in
            XCTAssertEqual(try! result.get(), .nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testStartCPUProfiler() {
        let expectation = self.expectation(description: "admin.startCPUProfiler")
        
        ava.admin.startCPUProfiler { result in
            XCTAssertEqual(try! result.get(), .nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testStopCPUProfiler() {
        let expectation = self.expectation(description: "admin.stopCPUProfiler")
        
        ava.admin.stopCPUProfiler { result in
            XCTAssertEqual(try! result.get(), .nil)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

