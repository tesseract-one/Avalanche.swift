import XCTest

import AvalancheTests
import Bech32Tests
import RPCTests

var tests = [XCTestCaseEntry]()
tests += AvalancheTests.__allTests()
tests += Bech32Tests.__allTests()
tests += RPCTests.__allTests()

XCTMain(tests)
