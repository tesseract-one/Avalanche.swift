//
//  MetricsTests.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import XCTest
@testable import Avalanche
    
final class MetricsTests: AvalancheTestCase {
    func testGetMetrics() {
        let expect = expectation(description: "metrics")
        
        ava.metrics.getMetrics { result in
            let metrics = try! result.get()
            XCTAssertFalse(metrics.isEmpty)
            
            expect.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

