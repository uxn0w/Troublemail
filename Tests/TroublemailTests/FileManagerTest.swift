
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
    var dataFetcher: DataFetcher!
    
    var blocklist = ["foo"]
    var filename = "testable.json"
    
    // MARK: - Setup
    override func setUp() {
        dataManager = StoringDataManager()
        dataManager.filename = filename
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
        dataManager.filename = "testable.json"

        dataManager.save(data: blocklist) { dataManager = nil }

        dataManager = StoringDataManager()
        dataManager.filename = "testable.json"


        let list = dataManager.load_uploaded()!
        XCTAssertEqual(list.count, 1)
        XCTAssertEqual(list[0], "foo")
    }
    
    /// Triggered when trying to get an update for the first time
    func testLoadWhenBlocklistGetUpdate() {
        
        dataManager = StoringDataManager()
        dataManager.filename = "testable.json"
        
        let before = ["foo", "bar"]
        dataManager.update_file(with: before)
        
        let list = dataManager.load_uploaded()!
        XCTAssertEqual(list.count, 2)
    }
    
    func testLoadDatabaseFileFromBundle() {
        XCTAssertNotNil(dataManager.load_included())
    }
    
    func testPublicFileNotExistsError() {
        dataManager.delete()
        XCTAssertNil(dataManager.load_uploaded())
    }
    
    func testInfixOperator() {
        let additional = ["bar"]
        XCTAssertNotEqual(blocklist, blocklist <- additional)
    }
}


