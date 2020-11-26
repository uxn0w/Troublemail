import XCTest
import Foundation
@testable import Troublemail

@available(iOS 12, OSX 10.13, *)
final class NetworkTests: XCTestCase {
    
    // MARK: - All tests
    static var allTests = [
        ("Host is correct",      testTaskUsesCorrectHost),
        ("Fetch and Parse Json", testSuccessfulFetchJsonAndParseBlocklist),
        ("Invalid JSON Object",  testInvalidJSONReturnsError),
        ("Response 404",         testFetchWhenResponseErrorReturns404),
        ("Response error",       testFetchWhenMissingHTTPResponse)
    ]
    
    // MARK: - Properties for testing
    private var emails = ["mail.ru", "google.com"]
    
    private var networking: Networking!
    private var mock      : URLSessionMock!
    
    // MARK: - Setup
    override func setUp() {
        self.networking = Networking()
        self.mock = URLSessionMock(data: nil, urlResponse: nil, responseError: nil)
        self.networking.session = mock
    }
    
    // MARK: - Help func
   
    private func task_getBlocklist() {
        let closure = {(status: CDNStatus<Blocklist>)  in }
        networking.getBlocklist(complitionHandler: closure)
    }
    
    private lazy var emailsData: Data = {
        return try! JSONSerialization.data(withJSONObject: emails, options: [])
    }()
    
    private lazy var emailsModel: Blocklist = {
        return Blocklist(json: emails.map { $0 as AnyObject } )!
    }()
    
    // MARK: - Test func
    
    func testTaskUsesCorrectHost() {
        task_getBlocklist()
        XCTAssertEqual(mock.UComponents?.host, "rawcdn.githack.com")
    }
    
    func testSuccessfulFetchJsonAndParseBlocklist() {
        let urlresponse = HTTPURLResponseMock()
        let expection   = expectation(description: "Successful Fetch Json")

        networking.session = URLSessionMock(data: emailsData,
                                            urlResponse: urlresponse,
                                            responseError: nil)
        var blocklist: Blocklist?
        
        networking.getBlocklist { (status) in
            switch status {
            case .success(let blocks): blocklist = blocks; expection.fulfill()
            case .failure(_):          XCTFail()
            }}
        
        wait(for: [expection], timeout: 4)
        XCTAssertEqual(blocklist!.block, emailsModel.block)
    }
    
    func testInvalidJSONReturnsError() {
        let urlresponse = HTTPURLResponseMock()
        let expection   = expectation(description: "Invalid JSON Data")
        var c_error: String?

        networking.session = URLSessionMock(data: Data(),
                                            urlResponse: urlresponse,
                                            responseError: nil)
        
        networking.getBlocklist { (status) in
            switch status {
            case .success(_):         XCTFail()
            case .failure(let error): c_error = error; expection.fulfill()
            }}
        
        wait(for: [expection], timeout: 4)
        XCTAssertNotNil(c_error)
    }
    
    func testFetchWhenResponseErrorReturns404() {
        let responseerror = NSError(domain: "Server Not Found", code: 404, userInfo: nil)
        let urlresponse   = HTTPURLResponseMock(code: 404)
        let expection     = expectation(description: "Server Not Found. 404 code.")
        var c_error: String?

        networking.session = URLSessionMock(data: nil, urlResponse: urlresponse, responseError: responseerror)
        
        networking.getBlocklist { (status) in
            switch status {
            case .success(_):         XCTFail()
            case .failure(let error): c_error = error; expection.fulfill()
            }}
    
        wait(for: [expection], timeout: 4)
        XCTAssertNotNil(c_error)
    }
    
    func testFetchWhenMissingHTTPResponse() {
        let expection     = expectation(description: "Missing http response")
        let responseerror = NSError(domain: NSURLErrorDomain, code: -1009, userInfo: nil)
        
        var c_error: String?
        
        networking.session = URLSessionMock(data: nil, urlResponse: nil, responseError: responseerror)
        
        networking.getBlocklist { (status) in
            switch status {
            case .success(_):         XCTFail()
            case .failure(let error): c_error = error; expection.fulfill()
            }}
        
        wait(for: [expection], timeout: 6)
        XCTAssertNotNil(c_error)
    }
}

@available(iOS 12, OSX 10.13, *)
extension NetworkTests {
    class URLSessionMock: URLSessionProtocol {
        
        var request: URLRequest?
        private let DataTaskMock: URLSessionDataTaskMock
        
        var UComponents: URLComponents? {
            guard let url = request?.url else { return nil }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
        }

        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            DataTaskMock = URLSessionDataTaskMock(
                data: data,
                urlResponse: urlResponse,
                responseError: responseError)
        }

        func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.request = request
            DataTaskMock.completionHandler = completionHandler
            return DataTaskMock
        }
    }
    
    class URLSessionDataTaskMock: URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias handler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: handler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
        
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler?(self.data, self.urlResponse, self.responseError)
            }
        }
    }
    
    class HTTPURLResponseMock: HTTPURLResponse {
        init(code: Int = 200) {
            let url = URL(string: "https://rawcdn.githack.com/disposable/disposable-email-domains/master/domains.json")!
            super.init(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
