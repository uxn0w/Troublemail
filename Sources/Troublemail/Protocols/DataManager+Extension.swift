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

typealias handler = () -> Void

@available(iOS 12, OSX 10.13, *)
protocol DataManager {
        
    var block: [String] { get }
    var blocklistURL: URL { get }
    
    func save(handler: handler)
    func load_loc()  -> [String]
    func load_pub()  -> [String]?
    func update_db() -> Void
}

@available(iOS 12, OSX 10.13, *)
extension DataManager {
    
    var blocklistURL: URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let docURL = url.first else { fatalError() }
        return docURL.appendingPathComponent("blocklist.json")
    }
    
    func save(handler: handler) {
        clean()
        do {
            guard JSONSerialization.isValidJSONObject(block) else { return logging.load.serializationError() }
            let data = try JSONSerialization.data(withJSONObject: block)
            try data.write(to: blocklistURL, options: [.atomicWrite]); handler()
        } catch { logging.load.serializationError() }
    }
    
    func load_pub() -> [String]? {
        do {
            let content = try Data(contentsOf: blocklistURL)

            guard
                let objects = try JSONSerialization.jsonObject(with: content, options: []) as? [String]
            else {
                logging.load.serializationError()
                return nil }
            
            return objects
            
        } catch {
            logging.load.fileNotExistsError()
            return nil
        }
    }
    
    func update_db() -> Void {
        guard
            let storage = load_pub()?.count else { save { logging.save.success(block.count) }; return }
        let difference = block.count - storage
        
        block.count != storage ? save {  logging.update.success(difference) } : logging.update.failure()
    }
    
    func load_loc() -> [String] {
            guard
                let url = Bundle.module.url(forResource: "blocklist", withExtension: "json")
            else { logging.load.fileNotExistsError(); return [String]() }

            do {
                let data = try Data(contentsOf: url)
                guard
                    let objects = try JSONSerialization.jsonObject(with: data, options: []) as? [String]
                else { return [String]() }
                
                return objects
            } catch { return [String]() }
        }
    
    private func clean() -> Void {
        try? FileManager.default.removeItem(at: blocklistURL)
    }
}
