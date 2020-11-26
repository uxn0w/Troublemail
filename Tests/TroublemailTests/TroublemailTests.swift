import XCTest
@testable import Troublemail

@available(iOS 12, OSX 10.13, *)
final class TroublemailTests: XCTestCase {
   
    // MARK: - All tests
    static var allTests = [
        ("Test func validate(for: ) for genuine domain name",      testValidateGenuineDomainName),
        ("Test func validate(for: ) for disposable domain name",   testValidateDisposableDomainName),
        ("Test func validate(for: ) for genuine email",            testValidateGenuineEmail),
        ("Test func validate(for: ) for disposable email",         testValidateDisposableEmail),
        ("Test func group(for: ) for list domain name and emails", testGroupingAllTypeEmailsAndDomainsNames)
    ]
    
    // MARK: - Properties for testing
    private var domainsAndEmails = ["gmail.com",          // genuine domain name
                                    "0-180.com",          // disposable domain name
                                    "User@gmail.com",     // genuine email
                                    "User@0-180.com"      // disposable email
                                    ]
    
    private var protocolMock: DMVProtocolMock!
    
    // MARK: - Setup
    override func setUp() {
        self.protocolMock = DMVProtocolMock()
    }
    
    func testValidateGenuineDomainName() {
        let genuine = domainsAndEmails[0]
        /// Function validate(for: ) accepts only email addresses
        XCTAssertFalse(protocolMock.validate(for: genuine))
    }
    
    func testValidateDisposableDomainName() {
        let disposable = domainsAndEmails[1]
        /// Will always return False. Domain name is not Email-address
        XCTAssertFalse(protocolMock.validate(for: disposable))
    }
    
    func testValidateGenuineEmail() {
        let genuie = domainsAndEmails[2]
        XCTAssertTrue(protocolMock.validate(for: genuie))
    }
    
    func testValidateDisposableEmail() {
        let dispoable = domainsAndEmails[3]
        XCTAssertFalse(protocolMock.validate(for: dispoable))
    }
    
    func testGroupingAllTypeEmailsAndDomainsNames() {
        let group = protocolMock.group(for: domainsAndEmails)
        
        XCTAssertEqual(group.domains.disposable, ["0-180.com"])
        XCTAssertEqual(group.domains.genuine,    ["gmail.com"])
        XCTAssertEqual(group.mails.disposable,   ["User@0-180.com"])
        XCTAssertEqual(group.mails.genuine,      ["User@gmail.com"])
    }
}

@available(iOS 12, OSX 10.13, *)
extension TroublemailTests {
    class DMVProtocolMock: DMVProtocol {
        var blocklist: [String]
        required init() {
            self.blocklist = ["0-180.com"]
        }
    }
}
