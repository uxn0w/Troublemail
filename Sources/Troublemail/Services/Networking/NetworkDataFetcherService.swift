/*
 * Copyright 2021 Uxnow.
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
typealias FetchComplitionHandler<T> = (T?, Error?) -> Void

// MARK: - Network Data Fetcher Service
protocol NetworkDataFetcherServiceProtocol {
    func fetch<T: Decodable>(request: URLRequest, complitionHandler: @escaping FetchComplitionHandler<T>)
}

class NetworkDataFetcherService: NetworkDataFetcherServiceProtocol {
    
    private var networkService: NetworkServiceProtocol
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.networkService = service
    }
    
    func fetch<T: Decodable>(request: URLRequest, complitionHandler: @escaping FetchComplitionHandler<T>) {
        networkService.task(request: request) { (data, response, error) in
            DispatchQueue.main.async(execute: { [unowned self] in
                guard let data = data else { return complitionHandler(nil, error)}
                guard let decodeData = self.decode(type: T.self, from: data) else { return complitionHandler(nil, entityError)}
                complitionHandler(decodeData, nil)
            })
        }.resume()
    }
    
    private func decode<T: Decodable>(type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch {
            return nil
        }
    }
    
    private let entityError = NSError(domain: "Network data fetcher service", code: 422,
                             userInfo: ["ENTITY_UNPROCESSABLE": "The request entity is JSON but it is not the right format"])
}
