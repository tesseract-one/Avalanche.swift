//
//  File.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import XCTest
@testable import Avalanche


    
final class MetricsTests: XCTestCase {
    func testGetMetrics() {
        let keychain = MockKeychainFactory()
        let ava = Avalanche(url: URL(string: "https://api.avax-test.network")!, keychains: keychain, network: .test)
        
        let expect = expectation(description: "metrics")
        
        ava.metrics.getMetrics { result in
            switch result {
            case .success(let value):
                XCTAssertFalse(value.isEmpty)
                break
            case .failure(let error):
                switch error {
                case .service(error: let se):
                    switch se {
                    case .connection(cause: let ce):
                        switch ce {
                        case .http(code: let code, message: _):
                            //The API of the test node is hidden
                            XCTAssertEqual(code, 404)
                        default:
                            XCTFail(ce.localizedDescription)
                        }
                    default:
                        XCTFail(se.localizedDescription)
                    }
                default:
                    XCTFail(error.localizedDescription)
                }
                break
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
    }

    static var allTests = [
        ("testGetMetrics", testGetMetrics),
    ]
}

