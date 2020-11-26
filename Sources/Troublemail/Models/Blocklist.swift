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

@available(iOS 12, OSX 10.13, *)
struct Blocklist: DataDecodable, DataManager {
   
    /// Local blocklist items storage
    var block: [String]
    
    /// Constructor that uses CDNManager Interface
    init?(json: [AnyObject]) {
        guard let block = json as? [String] else { return nil }
        self.block = block
    }
    
    /// Constructor that uses Provider Interface
    init() {
        self.block = [String]()
    }
}

