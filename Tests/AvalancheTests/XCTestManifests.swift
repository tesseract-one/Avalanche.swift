import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AvalancheHealthTests.allTests), testCase(AvalancheInfoTests.allTests),
    ]
}
#endif
