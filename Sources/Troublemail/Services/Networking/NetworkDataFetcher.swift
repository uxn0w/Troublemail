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

// MARK: - Network Data Fetcher

class NetworkDataFetcher {
    
    private var dataFetcher: NetworkDataFetcherServiceProtocol
    
    private var request: URLRequest {
        let url = URL(string: "https://rawcdn.githack.com/disposable/disposable-email-domains/master/domains.json")!
        return URLRequest(url: url)
    }
    
    init(dataFetcher: NetworkDataFetcherServiceProtocol = NetworkDataFetcherService()) {
        self.dataFetcher = dataFetcher
    }

    final func fetchBlocklist(completion: @escaping ([String]?, Error?) -> Void) {
        dataFetcher.fetch(request: request, complitionHandler: completion)
    }
}
