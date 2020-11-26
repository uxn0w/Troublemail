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

/// DVMCollection is a group divided into email addresses and domain names.
/// These containers have 2 properties genuine and disposable, which store
/// a list of data corresponding to the container.
public struct DMVCollection {
    
    /// A list of domain names that is a structure `container` with two
    /// properties `genuine` and `disposable`
    public let domains: DMVContainer
    
    /// A list of email's that is a structure `container` with two
    /// properties `genuine` and `disposable`
    public let mails: DMVContainer
}
