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

// MARK: - types
typealias CompletionSave = () -> Void

// MARK: - Protocol
@available(iOS 12, OSX 10.13, *)
protocol StoringDataManagerProtocol: class {
    
    var block: [String] { get }
    
    var filename: String! { get set }
    
    func delete()
    
    func load_included() -> [String]
    
    func load_uploaded() -> [String]?
    
    func update_file(with data: [String])
        
    func save(data: [String], completion: CompletionSave)
}
