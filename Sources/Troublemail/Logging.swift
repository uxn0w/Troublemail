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

import OSLog

@available(iOS 12, OSX 10.12, *)
extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let database = OSLog(subsystem: subsystem, category: "Database")
    static let network  = OSLog(subsystem: subsystem, category: "Networking")
}

@available(iOS 12, OSX 10.13, *)
struct logging {
    
    enum update {
        static var success: (Int) -> Void = { (value) in
            os_log("Update successful + %ld value mails in blocklist database", log: .network, value) }
        
        static var failure: () -> Void = {
            os_log("Database of one-time mail addresses is up-to-date!", log: .network) }
    }
    
    enum network {
        static var failure: (String) -> Void = { (error) in
            os_log("%ld", log: .database, error) }
    }
    
    enum load {
        static var serializationError: () -> Void = {
            os_log("Error in converting Foundation objects to JSON", log: .database) }
        
        static var fileNotExistsError: () -> Void = {
            os_log("File blocklist.json does not exist", log: .database) }
    }
    
    enum save {
        static var success: (Int) -> Void = { (value) in
            os_log("The database has been created. Count: %ld e-mails.", log: .database, value) }
    }
}
