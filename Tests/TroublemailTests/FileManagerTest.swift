
import XCTest
@testable import Troublemail

@available(iOS 12, OSX 10.13, *)
final class FileManagerTests: XCTestCase {
   
    // MARK: - All tests
    static var allTests = [
        ("", testWhenGettingDocumentsDirectoryURL),
        ("", testWhenTryingPrepareURL),
        ("", testInvalidData),
        ("", testValidJsonData),
        ("", testWhenProviderManagerRecreatedSaveBlocklistShouldBeEqual),
        ("", testLoadWhenBlocklistGetUpdate),
        ("", testLoadDatabaseFileFromBundle),
        ("", testPublicFileNotExistsError)
    ]
    
    // MARK: - Properties for testing
    var dataManager: StoringDataManager!
    var blocklist = ["foo"]
    var filename = "testable.json"
    
    // MARK: - Setup
    override func setUp() {
        dataManager = StoringDataManager()
    }
    
    // MARK: - Test DirectoryNamesProtocol
    
    func testWhenGettingDocumentsDirectoryURL() {
        XCTAssertNotNil(dataManager.documentsDirectoryURL())
    }
    
    func testWhenTryingPrepareURL() {
        XCTAssertNotNil(dataManager.prepareURL(with: "foo"))
    }
    
    // MARK: - Test JSONSerializationProtocol
    
    func testInvalidData() {
        let data = Data([1,2,3])
        XCTAssertNil(dataManager.foundationObject(from: data))
    }
    
    func testValidJsonData() {
        dataManager.jsonData(from: ["@d323f"]) { (data) in
            XCTAssertNotNil(data)
        }
    }
    
    // MARK: - Test CRUDFileManagerProtocol
    
    func testWhenProviderManagerRecreatedSaveBlocklistShouldBeEqual() {
        dataManager = StoringDataManager()
        dataManager.save(name: filename, data: blocklist) { dataManager = nil }
        
        dataManager = StoringDataManager()

        let list = dataManager.load_pub(name: filename)!
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0], "foo")
    }
    
    /// Triggered when trying to get an update for the first time
    func testLoadWhenBlocklistGetUpdate() {
                
        let before = ["foo", "bar"]
        dataManager.update(name: filename, with: before)
        
        let list = dataManager.load_pub(name: filename)!
        XCTAssertEqual(list.count, 2)
    }
    
    func testLoadDatabaseFileFromBundle() {
        XCTAssertNotNil(dataManager.load_loc())
    }
    
    func testPublicFileNotExistsError() {
        dataManager.delete(name: filename)
        XCTAssertNil(dataManager.load_pub(name: filename))
    }
}


