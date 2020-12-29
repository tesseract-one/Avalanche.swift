//
//  TestCaseBase.swift
//  
//
//  Created by Yehor Popovych on 12/27/20.
//

import XCTest
import Avalanche

class AvalancheTestCase: XCTestCase {
    private static func test(_ test: AvalancheTestCase.Type, enabled: Bool) -> (AvalancheTestCase.Type, Bool) {
        (test, enabled)
    }
    
    private static func _registry(_ fac: ()->[(AvalancheTestCase.Type, Bool)]) -> [String: Bool] {
        Dictionary(uniqueKeysWithValues: fac().map {(String(describing: $0.0), $0.1)})
    }
    
    private static var testEnabled: Bool {
        registry[String(describing: self)] ?? true //enabled by default
    }
    
    static let registry = _registry {
        [
         test(AdminTests.self, enabled: true),
         test(AuthTests.self, enabled: false), //reenable with the node that supports the API
         test(HealthTests.self, enabled: true),
         test(InfoTests.self, enabled: true),
         test(IPCTests.self, enabled: false), //reenable with the node that supports the API
         test(KeystoreTests.self, enabled: true),
         test(MetricsTests.self, enabled: false), //reenable with the node that supports the API
        ]
    }
    
    let keychain = MockKeychainFactory()
    var ava:Avalanche!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        try XCTSkipUnless(Self.testEnabled, "Test disabled in config")
        
        self.ava = Avalanche(url: URL(string: "https://api.avax-test.network")!, keychains: keychain, network: .test)
    }
}
