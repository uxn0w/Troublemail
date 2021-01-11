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

/// **Validator** class is a set of methods and properties implemented in
/// the Protocol extension **DMVProtocol**.
///
/// **DMVProtocol** is a Protocol for validation an email address or group of email
/// addresses for compliance with RFC 5322 (sections 3.2.3 and 3.4.1) and absence of
/// an email address in the blacklist.
/// - Author: uxnow | [Github page](https://github.com/uxn0w)
/// - Version: 1.0
@available(iOS 12, OSX 10.13, *)
public class Troublemail: DMVProtocol {
    
    private var model = Blocklist()
    
    public var blocklist: [String] {
        guard
            let blocklist = model.load_pub()
        else { return model.load_loc() }
        return blocklist
    }
    
    public static func Configure() {
        let network = NetworkDataFetcher()
        network.fetchBlocklist { (data, error) in
            guard let data = data else {
                logging.network.failure(error?.localizedDescription ?? "Network error")
                return }
            Blocklist(list: data).update_db()
        }
    }
}
