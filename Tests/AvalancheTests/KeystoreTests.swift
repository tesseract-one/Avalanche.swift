//
//  File.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import Foundation

import XCTest
@testable import Avalanche

import RPC
    
final class KeystoreTests: AvalancheTestCase {
    let username = String("testuser") + String(UInt64.random(in: 0..<UInt64.max))
    let password = "p@@@$$$123#$%" //Mmm... Secure!
        
    override func setUp() {
        super.setUp()
        
        let expectation = self.expectation(description: "setup")
        
        ava.keystore.createUser(username: username, password: password) { result in
            XCTAssertEqual(try! result.get(), .nil)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    override func tearDown() {
        let expectation = self.expectation(description: "setup")
        
        ava.keystore.deleteUser(username: username, password: password) { result in
            XCTAssertEqual(try! result.get(), .nil)
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
        
        super.tearDown()
    }
    
    func testListUsers() {
        let expectation = self.expectation(description: "keystore.listUsers")
        
        let ava = self.ava!
        let username = self.username
        
        ava.keystore.listUsers { response in
            let users = try! response.get()
            
            XCTAssertFalse(users.filter {$0 == username}.isEmpty)
            
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testExImDeleteUser() {
        let expectationExportDefEnc = self.expectation(description: "keystore.exportUserDefEnc")
        
        let ava = self.ava!
        let username = self.username
        let password = self.password
        
        ava.keystore.exportUser(username: username, password: password) { response in
            XCTAssertEqual(try! response.get().encoding, .cb58)
            expectationExportDefEnc.fulfill()
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
        
        let expectationExport = self.expectation(description: "keystore.exportUser")
        let expectationImport = self.expectation(description: "keystore.importUser")
        let expectationDelete = self.expectation(description: "keystore.deleteUser")
        
        ava.keystore.exportUser(username: username, password: password, encoding: .hex) { response in
            let export = try! response.get()
            XCTAssertEqual(export.encoding, .hex)
            expectationExport.fulfill()
            
            let userim = username + "import"
            
            ava.keystore.importUser(username: userim, password: password, user: export.user, encoding: export.encoding) { response in
                XCTAssertEqual(try! response.get(), .nil)
                expectationImport.fulfill()
                
                ava.keystore.deleteUser(username: userim, password: password) { response in
                    XCTAssertEqual(try! response.get(), .nil)
                    expectationDelete.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    static var allTests = [
        ("testListUsers", testListUsers),
    ]
}
