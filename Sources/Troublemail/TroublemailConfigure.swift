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

@available(iOS 12, OSX 10.13, *)
public struct TroubleMailConfigure {
    
    // MARK: Service
    private let storage = StoringDataManager()
    private let network = NetworkDataFetcher()
    
    private let filename: String
    
    public init(filename: String = "blocklist.json") {
        self.filename = filename
    }
    
    public func receiveUpdate() {
        network.fetchBlocklist { [self] (data, error) in
            guard let data = data else {
                logging.network.failure(error?.localizedDescription ?? "Network error")
                return
            }
            storage.update(name: filename, with: data)
        }
    }
}

