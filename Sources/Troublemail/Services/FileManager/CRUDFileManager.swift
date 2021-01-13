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
typealias saveCompletion = () -> Void

// MARK: - Protocol
@available(iOS 12, OSX 10.13, *)
protocol CRUDFileManagerProtocol: DirectoryNamesProtocol, JSONSerializationProtocol {
    
    var block: [String] { get }
    
    func delete(name: String)
    
    func load_loc() -> [String]
    
    func load_pub(name: String) -> [String]?
    
    func update(name: String, with data: [String])
        
    func save(name: String, data: [String], completion: saveCompletion)
}

// MARK: -
@available(iOS 12, OSX 10.13, *)
extension CRUDFileManagerProtocol {
    
    func load_loc() -> [String] {
        
        let defaultValue = [String]()
        
        guard
            let url = Bundle.module.url(forResource: "blocklist", withExtension: "json")
        else {
            logging.load.fileNotExistsError(); return defaultValue
        }
        
        do {
            let data = try Data(contentsOf: url)
            guard let blocklist = foundationObject(from: data) else { return defaultValue }
            return blocklist
        }
        catch {
            return defaultValue
        }
    }
    
    func load_pub(name: String) -> [String]? {
        do {
            let data = try Data(contentsOf: prepareURL(with: name))
            guard let blocklist = foundationObject(from: data) else { return nil }
            return blocklist
        }
        catch {
            logging.load.fileNotExistsError(); return nil
        }
    }
    
    func update(name: String, with data: [String]) {
        guard
            let storage = load_pub(name: name)?.count else { save(name: name, data: data) { logging.save.success(block.count) }; return }
        let difference = data.count - storage

        block.count != storage
            ? save(name: name, data: data) { logging.update.success(difference) }
            : logging.update.failure()
    }
    
    func save(name: String, data: [String], completion: saveCompletion) {
        jsonData(from: data) { (data) in
            guard let data = data else { return }
            do {
                try data.write(to: prepareURL(with: name), options: [.atomicWrite])
            }
            catch {
                logging.load.serializationError()
            }
            completion()
        }
    }
    
    func delete(name: String) {
        try? FileManager.default.removeItem(at: prepareURL(with: name))
    }
    
}
