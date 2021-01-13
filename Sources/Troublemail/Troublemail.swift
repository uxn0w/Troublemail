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

/// `DMVProtocol` is a Protocol for validation an email address or group of email
/// addresses for compliance with RFC 5322 (sections 3.2.3 and 3.4.1) and absence of
/// an email address in the blacklist.
public protocol DMVProtocol {
    
    /// Storage of one-time mail domains
    var blocklist : [String] { get }
    
    
    /// Validating email domain name using Regex (RFC 5322 Official Standard)
    /// and search this domain name in the blacklist.
    ///
    /// The private `isEmail` function implemented in `DMVProtocol` verifies
    /// that email addresses comply with RFC 5322 (sections 3.2.3 and 3.4.1) and
    /// RFC 5321 - with a more readable form given in the informational RFC 3696[a]
    /// and the associated errata.
    ///
    /// - Parameters:
    ///   - mail: An email-address that requires verification.
    /// - Returns: bool value that determines whether the domain passed validation.
    func validate(for mail : String) -> Bool
    
    
    /// Grouping mail domain names & email-addresses by `genuine` & `disposable` type.
    ///
    ///
    /// It is important to remember that the function accepts not only a list of
    /// domain names, but also a list of email addresses.
    /// # Example #
    ///     // Init Troublemail() class
    ///     let temp = Troublemail()
    ///
    ///     // Define a list domain name & email's
    ///     let domains = ["gmail.com", "disposable.com",
    ///                    "Bob@gmail.com", "Alice@disposable.com"]
    ///
    ///     // Use the group(list: ) method to get a collections
    ///     // with `genuine` and `disposable` mail list.
    ///     let grouped = temp.group(list: domains)
    ///
    ///     print(grouped.mails)
    ///     // DMVContainer(genuine: ["Bob@gmail.com"], disposable: ["Alice@disposable.com"])
    ///
    ///     print(grouped.domains)
    ///     // DMVContainer(genuine: ["gmail.com"], disposable: ["disposable.com"])
    ///
    /// - Attention: **DVMCollection** is a group divided into email addresses and domain names.
    ///  These containers have 2 properties `genuine` and `disposable`, which store
    ///  a list of data corresponding to the container.
    ///
    /// - Parameters:
    ///   - list: List of domain names (Second level of the domain + top level of the domain)
    ///   & email-addresses to group.
    /// - Returns: DVMCollection -> DMVContainer | DMVContainer  -> genuine | disposable
    func group(for list : Array<String>) -> DMVCollection
}


/// Implementation of Protocol `DMVProtocol` methods.
public extension DMVProtocol {
    
    func validate(for mail: String) -> Bool {
        
        guard isEmail(candidate: mail) else { return false }
        
        let regex = "[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let range = mail.range(of: regex, options: .regularExpression)!
        
        let domain = String(describing: mail[range])
        
        return !blocklist.contains(domain)
    }
    
    func group(for list: Array<String>) -> DMVCollection {
        
        /// Define the `mails` & `domains` property as! `DMVContainer`.
        var (mails, domains) = (DMVContainer(), DMVContainer())
        
        /// Filtering by domain name and build the container using the reduce function().
        domains = list
            .filter { !isEmail(candidate: $0) }
            .reduce(into: (domains) ) { blocklist.contains($1) ? $0.disposable.append($1) : $0.genuine.append($1) }
        
        /// Filtering by mail-address and build the container using the reduce function().
        mails = list
            .filter { isEmail(candidate: $0) }
            .reduce(into: (mails)) { !validate(for: $1) ? $0.disposable.append($1) : $0.genuine.append($1) }
        
        return DMVCollection(domains: domains, mails: mails)
    }

    private func isEmail(candidate: String) -> Bool {
        /// General Email Regex (RFC 5322 Official Standard)
        let expression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", expression).evaluate(with: candidate)
    }
}

/// **Troublemail** class is a set of methods and properties implemented in
/// the Protocol extension **DMVProtocol**.
///
/// **DMVProtocol** is a Protocol for validation an email address or group of email
/// addresses for compliance with RFC 5322 (sections 3.2.3 and 3.4.1) and absence of
/// an email address in the blacklist.
/// - Author: uxnow | [Github page](https://github.com/uxn0w)
/// - Version: 1.0
@available(iOS 12, OSX 10.13, *)
public struct Troublemail: DMVProtocol {
    
    public init() {}
    
    // MARK: - Service
    private var storage = StoringDataManager()
    
    // MARK: - Property
    public var blocklist: [String] {
        return storage.block
    }

}


