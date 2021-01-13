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

// MARK: - Protocol
@available(iOS 12, OSX 10.13, *)
protocol JSONSerializationProtocol {
    
    /// Returns a Array<String> from given JSON data.
    func foundationObject(from data: Data) -> [String]?
    
    /// Returns JSON data from a Foundation object.
    func jsonData(from list: [String], completion: (Data?) -> Void)
    
}

// MARK: -
@available(iOS 12, OSX 10.13, *)
extension JSONSerializationProtocol {
    
    func foundationObject(from data: Data) -> [String]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String]
        }
        catch {
            logging.load.serializationError()
            return nil
        }
    }
    
    func jsonData(from list: [String], completion: (Data?) -> Void) {
        do {
            let data = try JSONSerialization.data(withJSONObject: list)
            completion(data)
        }
        catch {
            logging.load.serializationError()
            completion(nil)
        }
    }
}
