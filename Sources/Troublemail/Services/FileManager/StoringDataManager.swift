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
class StoringDataManager: StoringDataManagerProtocol, DirectoryNamesProtocol, JSONSerializationProtocol {
    
    // MARK: - Property
    var block: [String] {
        guard let blocklist = load_uploaded()
        else { return load_included() }
        return blocklist
    }
    
    var filename: String!
    
    // MARK: -
    func load_included() -> [String] {
        
        let defaultValue = [String]()
        
        guard
            let url = Bundle.module.url(forResource: "blocklist", withExtension: "json")
        else {
            logging.load.fileNotExistsError(); return defaultValue
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            guard
                let blocklist = foundationObject(from: data)
            else {
                return defaultValue
            }
            
            return blocklist
        }
        catch {
            return defaultValue
        }
    }
    
    // MARK: -
    func load_uploaded() -> [String]? {
        do {
            let data = try Data(contentsOf: prepareURL(with: filename))
            guard
                let blocklist = foundationObject(from: data)
            else {
                return nil
            }
            return blocklist
        }
        catch {
            logging.load.fileNotExistsError(); return nil
        }
    }
    
    // MARK: -
    func update_file(with data: [String]) {
        guard
            let storage = load_uploaded()?.count
        else {
            save(data: data) { logging.save.success(block.count) }; return
        }
        
        let difference = data.count - storage

        data.count != storage
            ? save(data: data) { logging.update.success(difference) }
            : logging.update.failure()
    }
    
    // MARK: -
    func save(data: [String], completion: CompletionSave) {
        jsonData(from: data) { (data) in
            guard let data = data else { return }
            do {
                try data.write(to: prepareURL(with: filename), options: [.atomicWrite])
            }
            catch {
                logging.load.serializationError()
            }
            completion()
        }
    }
    
    // MARK: -
    func delete() {
        try? FileManager.default.removeItem(at: prepareURL(with: filename))
    }
}

