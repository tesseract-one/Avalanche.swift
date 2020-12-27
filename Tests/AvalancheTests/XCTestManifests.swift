import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HealthTests.allTests), testCase(InfoTests.allTests), testCase(MetricsTests.allTests), testCase(AdminTests.allTests),
    ]
}
#endif
