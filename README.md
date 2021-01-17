![Logo][logo]

[![Swift][swift-badge]][swift-url]
[![License][apache-badge]][apache-url]
![Platform][platform]
[![codecov](https://codecov.io/gh/uxn0w/Troublemail/branch/main/graph/badge.svg?token=RCQBANQBSH)](https://codecov.io/gh/uxn0w/Troublemail)

**Troublemail** is a framework that helps you determine one-time and temporary email addresses and email services. The database has more than 100,000 domain names blacklisted, and is updated in real time, so you don't have to update the framework, just have an Internet connection when using it. Now, someone will not be so easy to log in to your service using a one-time or temporary email address.

## Getting Started

### Requirements
- **Platform:** OS X 10.13 / iOS 12 or later
- **Swift version:** Swift 5.x

### Installation

#### Swift Package Manager
To include Troublemail into a Swift Package Manager package, add it to the `dependencies` attribute defined in your `Package.swift` file. You can select the version using the `majorVersion` and `minor` parameters. For example:
```ruby
dependencies: [
  .Package(url: "https://github.com/uxn0w/Troublemail.git", majorVersion: <majorVersion>, minor: <minor>)
    ]
```

### Usage
#### Configure
The first thing to do is to declare an auto-update of the database. If you couldn't get the database update for any reason, don't worry, the local storage contains the database of 20 Oct 2020.

**Recommend:** In file AppDelegate.swift, we `import Troublemail` module and in `application:didFinishLaunchingWithOptions:` method, we call the `receiveUpdate()` method of the `TroubleMailConfigure` class. You can set your own file name  `TroubleMailConfigure(name: "somename.json"`.
```swift
let tempConfigure = TroubleMailConfigure()
tempConfigure.receiveUpdate()
```

#### Validate
Validating email domain name using Regex (RFC 5322 Official Standard) and search this domain name in the blacklist.
```swift
let temp = Troublemail()

let disposable_mail = "User@d1sposable.com"
let genuine_mail = "User@gmail.com"
let trash_mail = "User@gm$ailc.pm"

// It's false. Domain name in blocklist.
temp.validate(for : disposable_mail)

// It's true. 
temp.validate(for : genuine_mail)    

// It's false. In the second-level domain name found a special symbol.
temp.validate(for : trash_mail)      

```

#### Grouping
Grouping mail domain names and email-addresses by `genuine` & `disposable` type.
`DVMCollection` is a group divided into email addresses and domain names.
These containers have 2 properties `genuine` and `disposable`, which store a list of data corresponding to the container.    
```swift

let temp = Troublemail()

let domains = ["gmail.com", "disposable.com",
               "Bob@gmail.com", "Alice@disposable.com"]

let grouped = temp.group(list: domains)

// RETURN: DMVContainer(genuine: ["Bob@gmail.com"], disposable: ["Alice@disposable.com"])
grouped.mails

// RETURN: DMVContainer(genuine: ["gmail.com"], disposable: ["disposable.com"])
grouped.domains

```

#### Blocklist 
`blocklist` is a storage of one-time mail domains. Return type [String].
```swift

let temp = Troublemail()

temp.blocklist
```
You can also add your own list to the database. 
If some domain names are not included in the CDN, just use `additional(blocklist: [String])` 
```swift

let temp = Troublemail()
let ownDomains = ["foo.com"]

// Adding domain names
temp.additional(blocklist: ownDomains)

// Deleting domain names
temp.removeAdditional()

```

## Gratitude
I Express my gratitude to **[Stefan Meinecke ](https://github.com/smeinecke)** and to project **[disposable](https://github.com/disposable/disposable)** with his **[contributors](https://github.com/disposable/disposable/graphs/contributors)** for providing the CDN.

## License
This project is released under the Apache-2 license. See [LICENSE.md](LICENSE) for details.

[swift-badge]: https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat
[swift-url]: https://swift.org
[apache-badge]: https://img.shields.io/badge/License-Apache%202-blue.svg?style=flat
[apache-url]: LICENSE
[logo]: https://i.ibb.co/sFvn3Dm/Frame-3.png
[platform]: https://img.shields.io/badge/Platform-iOS%20%7C%20OSX%20-%23989898
