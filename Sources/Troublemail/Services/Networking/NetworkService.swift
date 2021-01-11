/*
 * Copyright 2020 Uxnow.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import Foundation

// MARK: - Types
typealias TaskComplitionHandler  = (Data?, HTTPURLResponse?, Error?) -> Void

// MARK: - Network Service
protocol NetworkServiceProtocol {
    var session: URLSessionProtocol { get set }
    func task(request: URLRequest, complitionHandler: @escaping TaskComplitionHandler) -> URLSessionDataTask
}

class NetworkService: NetworkServiceProtocol {
    
    var session: URLSessionProtocol
    
    init(withSession session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
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
                complitionHandler(content, HTTPResponse, nil)
            default: break
            }
            
        }
        return dataTask
    }
}
