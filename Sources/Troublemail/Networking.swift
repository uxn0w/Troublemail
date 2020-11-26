/*
 * Created by Uxnow
 * 2020/11/25
 * ----------------------------------------------------------------------------------------------
 * CDN source: https://rawcdn.githack.com/disposable/disposable-email-domains/master/domains.json
 * Github:     https://github.com/disposable/disposable
*/

import Foundation

// MARK: - Additions to the interface implementation
typealias TaskComplitionHandler  = ([AnyObject]?, HTTPURLResponse?, Error?) -> Void

enum CDNStatus<T> { case success(T), failure(String?) }

protocol DataDecodable { init?(json: [AnyObject]) }

// MARK: - Extension URLSession for testing
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

// MARK: - Interface
@available(iOS 12, OSX 10.13, *)
protocol CDNManager {
    
    var session: URLSessionProtocol { get }
        
    func task(request: URLRequest, complitionHandler: @escaping TaskComplitionHandler) -> URLSessionDataTask
    
    func fetch<T: DataDecodable>(request: URLRequest, parse: @escaping ([AnyObject]) -> T?, complitionHandler: @escaping ((CDNStatus<T>) -> Void))
}

// MARK: Extension interface
@available(iOS 12, OSX 10.13, *)
extension CDNManager {
    
    func task(request: URLRequest, complitionHandler: @escaping TaskComplitionHandler) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let HTTPResponse = response as? HTTPURLResponse else {
                complitionHandler(nil, nil, error)
                return
            }
            
            guard let content = data else {
                complitionHandler(nil, HTTPResponse, error)
                return
            }
            
            switch HTTPResponse.statusCode {
            case 200:
                do {
                    let json = try JSONSerialization.jsonObject(with: content) as? [AnyObject]
                    complitionHandler(json, HTTPResponse, nil)
                    
                } catch let error as NSError {
                    complitionHandler(nil, HTTPResponse, error)
                }
            default: break
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping ([AnyObject]) -> T?, complitionHandler: @escaping (CDNStatus<T>) -> Void) {
        let dataTask = task(request: request) { (json, response, error) in
            DispatchQueue.main.async(execute: {
                guard let json = json else {
                    if let error = error {
                        complitionHandler(.failure(error.localizedDescription))
                    };return}
                
                if let value = parse(json) {
                    complitionHandler(.success(value))
                } else {
                    let error = NSError(domain: "Domain error", code: 200, userInfo: nil)
                    complitionHandler(.failure(error.localizedDescription))
                }
            })
        }
        dataTask.resume()
    }
}

// MARK: - Implementation CDNManager
@available(iOS 12, OSX 10.13, *)
class Networking: CDNManager {
    
    var session: URLSessionProtocol
    
    init(withSession session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    var request: URLRequest {
        let url = URL(string: "https://rawcdn.githack.com/disposable/disposable-email-domains/master/domains.json")!
        return URLRequest(url: url)
    }
    
    func getBlocklist(complitionHandler: @escaping (CDNStatus<Blocklist>) -> Void) {
        fetch(request: request,
              parse: { (json) -> Blocklist? in return Blocklist(json: json)},
              complitionHandler: complitionHandler)
    }
}

