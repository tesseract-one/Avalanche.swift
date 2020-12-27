import XCTest

import Avalanche

class AvalancheTestCase: XCTestCase {
    private static func test(_ test: AvalancheTestCase.Type, enabled: Bool) -> (AvalancheTestCase.Type, Bool) {
        (test, enabled)
    }
    
    private static func _registry(_ fac: ()->[(AvalancheTestCase.Type, Bool)]) -> [String: Bool] {
        Dictionary(uniqueKeysWithValues: fac().map {($0.0.className(), $0.1)})
    }
    
    private static var testEnabled: Bool {
        registry[self.className()] ?? true //enabled by default
    }
    
    override class var defaultTestSuite: XCTestSuite {
        let defaultTS = super.defaultTestSuite
        
        return testEnabled ? defaultTS : XCTestSuite(name: defaultTS.name)
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
    
    override func setUp() {
        super.setUp()
        
        self.ava = Avalanche(url: URL(string: "https://api.avax-test.network")!, keychains: keychain, network: .test)
    }
}

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HealthTests.allTests), testCase(InfoTests.allTests), testCase(MetricsTests.allTests), testCase(AdminTests.allTests),
    ]
}
#endif
