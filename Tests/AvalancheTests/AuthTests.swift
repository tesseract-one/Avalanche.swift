//
//  File.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import XCTest
@testable import Avalanche

import RPC
    
final class AuthTests: XCTestCase {
    let keychain = MockKeychainFactory()
    var ava:Avalanche!
    
    let password = "password"
    let passwordNew = "passwordNew"
        
    override func setUp() {
        ava = Avalanche(url: URL(string: "https://api.avax-test.network")!, keychains: keychain, network: .test)
    }
    
    func testNewRevokeToken() {
        let expectationNew = self.expectation(description: "auth.newToken")
        let expectationRevoke = self.expectation(description: "auth.revokeToken")
        
        let ava = self.ava!
        let password = self.password
        
        ava.auth.newToken(password: password, endpoints: ["/ext/bc/X", "/ext/info"]) { result in
            let token = try! result.get()
            
            XCTAssertFalse(token.isEmpty)
            expectationNew.fulfill()
            
            ava.auth.revokeToken(password: password, token: token) { result in
                XCTAssertEqual(try! result.get(), .nil)
                expectationRevoke.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChangePassword() {
        let expectation1 = self.expectation(description: "auth.changePassword1")
        let expectation2 = self.expectation(description: "auth.changePassword2")
        
        let ava = self.ava!
        let password = self.password
        let passwordNew = self.passwordNew
        
        ava.auth.changePassword(password: password, newPassword: passwordNew) { result in
            XCTAssertEqual(try! result.get(), .nil)
            expectation1.fulfill()
            
            ava.auth.changePassword(password: passwordNew, newPassword: password) { result in
                XCTAssertEqual(try! result.get(), .nil)
                expectation2.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    static var allTests = [
        ("testNewRevokeToken", testNewRevokeToken),
    ]
}

