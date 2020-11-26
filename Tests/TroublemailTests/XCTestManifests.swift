import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TroublemailTests.allTests),
        testCase(NetworkTests.allTests),
        testCase(BlocklistDMTests.allTests)
    ]
}
#endif
