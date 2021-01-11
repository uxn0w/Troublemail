import XCTest
@testable import Troublemail

@available(iOS 12, OSX 10.13, *)
final class BlocklistDMTests: XCTestCase {
    
    // MARK: - All tests
    static var allTests = [
        ("Save blocklist and recreate Model with load",   testWhenProviderManagerRecreatedSaveBlocklistShouldBeEqual),
        ("Load blocklist before update",                  testLoadWhenBlocklistGetUpdate),
        ("Testing File Not Exists Error",                 testWhenLoadFileNotExistsError),
        ("Testing Load when update return nil in storage",testWhenUpdateGetNilInLoadAndSaveNewBlocklist),
        ("Testing Save func in update scope conditions",  testWhenUpdateEqualInternalJsonStorage),
        ("Testing load database file from local storage", testLoadDatabaseFileFromBundle)
    ]
    
    // MARK: - Properties for testing
    var blocklist: Blocklist!
    var provider:  ProviderMock!
    var validator: Troublemail!
    
    // MARK: - Setup
    override func setUp() {
        blocklist = Blocklist()
        provider  = ProviderMock()
        validator = Troublemail()
    }
    
   // MARK: - Test func
    
    func testWhenProviderManagerRecreatedSaveBlocklistShouldBeEqual() {
        blocklist = Blocklist()
        blocklist.block = ["0-180.com"]
        blocklist.save { blocklist = nil }
        
        blocklist = Blocklist()
        
        let list = blocklist.load_pub()!
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0], "0-180.com")
    }
    
    func testLoadWhenBlocklistGetUpdate() {
        /// The result of update
        blocklist.block = ["0-180.com", "dc3r.ru"]
        blocklist.update_db()
        
        XCTAssertEqual(blocklist.load_pub()!.count, 2)
    }
    
    func testWhenLoadFileNotExistsError() {
        provider = ProviderMock()
        XCTAssertNil(provider.load_pub())
    }
    
    /// Triggered when trying to get an update for the first time
    func testWhenUpdateGetNilInLoadAndSaveNewBlocklist() {
        provider = ProviderMock()
        /// Blocklist get from CDN
        provider.block = ["0-180.com", "dc3r.ru"]
        provider.update_db()
        
        XCTAssertNotNil(provider.load_pub())
    }
    
    func testWhenUpdateEqualInternalJsonStorage() {
        blocklist.block = ["0-180.com", "dc3r.ru"]
        blocklist.update_db()
        XCTAssertEqual(blocklist.block.count, blocklist.load_pub()?.count)
    }
    
    func testLoadDatabaseFileFromBundle() {
        let provider = ProviderMock()
        XCTAssertNotNil(provider.load_loc())
    }
}

@available(iOS 12, OSX 10.13, *)
extension BlocklistDMTests {
    class ProviderMock: DataManager {
        var block: [String] = []
        
        init() {
            try? FileManager.default.removeItem(at: blocklistURL)
        }
        
        var blocklistURL: URL {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            guard let docURL = url.first else { fatalError() }
            return docURL.appendingPathComponent("testable_blocklist.json")
        }
    }
}
