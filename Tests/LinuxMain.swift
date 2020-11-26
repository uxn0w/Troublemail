import XCTest

import TroublemailTests

var tests = [XCTestCaseEntry]()
tests += TroublemailTests.allTests()
tests += BlocklistDMTests.allTests()
tests += NetworkTests.allTests()

XCTMain(tests)
