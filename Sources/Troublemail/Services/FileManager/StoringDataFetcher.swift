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

// MARK: - Storing Data Fetcher

enum DataSource {
    case custom, included, uploaded
}

@available(iOS 12, OSX 10.13, *)
class DataFetcher {
    
    // MARK: - Service
    private var dataManager: StoringDataManagerProtocol
    
    // MARK: - Property
    private var additional = [String]()
    
    init(filename: String = "blocklist.json",
         dataManager: StoringDataManagerProtocol = StoringDataManager()) {
        self.dataManager = dataManager
        self.dataManager.filename = filename
    }
    
    // MARK: - DataFetcher Uses methods
    
    final func load(from source: DataSource) -> [String] {
        switch source {
        case .custom: return additional
        case .included: return dataManager.load_included() <- additional
        case .uploaded: return (dataManager.load_uploaded() ?? dataManager.load_included()) <- additional
        }
    }
    
    final func setAdditional(blocklist: [String]) {
        additional = additional <- blocklist
    }
    
    final func update(with data: [String]) {
        dataManager.update_file(with: data)
    }
    
    final func removeAdditional() {
        additional.removeAll()
    }
    
    final func remove() {
        dataManager.delete()
    }
}

