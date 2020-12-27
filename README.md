# Avalanche.swift - The Avalanche Platform Swift Library

[![GitHub license](https://img.shields.io/badge/license-Apache%202.0-lightgrey.svg)](LICENSE)
[![Build Status](https://github.com/tesseract-one/Avalanche.swift/workflows/Build%20%26%20Tests/badge.svg?branch=main)](https://github.com/tesseract-one/Avalanche.swift/actions?query=workflow%3ABuild%20%26%20Tests+branch%3Amain)
[![GitHub release](https://img.shields.io/github/release/tesseract-one/Avalanche.swift.svg)](https://github.com/tesseract-one/sAvalanche.swift/releases)
[![SPM compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods version](https://img.shields.io/cocoapods/v/Avalanche.svg)](https://cocoapods.org/pods/Avalanche)
![Platform OS X | iOS | tvOS | watchOS](https://img.shields.io/badge/platform-OS%20X%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-orange.svg)

## Overview 

Avalanche.swift is a Swift Library for interfacing with the Avalanche Platform. The library allows one to issue commands to the Avalanche node APIs. 

The APIs currently supported (the rest is coming really soon) are:

 * [x] Admin API
 * [x] Auth API
 * [ ] AVM API (X-Chain)
 * [ ] EVM API (C-Chain)
 * [x] Health API
 * [x] Info API
 * [x] IPC API
 * [x] Keystore API
 * [x] Metrics API
 * [ ] PlatformVM API (P-Chain)

We built Avalanche.swift with ease of use in mind. With this library, any Swift developer is able to interact with a node on the Avalanche Platform who has enabled their API endpoints for the developer's consumption. We keep the library up-to-date with the latest changes in the [Avalanche Platform Specification](https://docs.avax.network). 

  Using Avalanche.swift, developers can:

  * Locally manage private keys
  * Retrieve balances on addresses
  * Get UTXOs for addresses
  * Build and sign transactions
  * Issue signed transactions to the X-Chain
  * Create a Subnetwork
  * Administer a local node
  * Retrieve Avalanche network information from a node
  * Call smart-contracts on C-Chain

### Requirements

Avalanche.swift deploys to macOS 10.10+, iOS 9+, watchOS 2+, tvOS 9+ and requires Swift 5.0 or higher to compile.

### Installation

- **Swift Package Manager:**
  Add this to the dependency section of your `Package.swift` manifest:

    ```Swift
    .package(url: "https://github.com/tesseract-one/Avalanche.swift.git", from: "0.1.0")
    ```

- **CocoaPods:** Put this in your `Podfile`:

    ```Ruby
    pod 'Avalanche', '~> 0.1'
    ```

## Examples

### Calling APIs

The APIs are accessible fields on an Avalanche instance (info, health, etc.). Here is an example for a `info.getNetworkID` method call. The methods in the library are identical to the methods described in the main API [documentation](https://docs.avax.network/build/avalanchego-apis):

```Swift
let ava = Avalanche(url: URL(string: "https://api.avax-test.network")!, network: .test)
    
    ava.info.getNetworkID { result in
        switch result {
        case .success(let id):
            print("ID is: ", id)
        case .failure(let error):
            print("Error occured: ", error)
        }
    }
```

### Managing X-Chain Keys

Avalanche.swift comes with its own In-App Keychain. This KeyChain is used in the functions of the API, enabling them to sign using keys it's registered. The first step in this process is to create an instance of Avalanche.swift connected to our Avalanche Platform endpoint of choice.

```Swift
import Avalanche

let ava = Avalanche(url: URL(string: "http://localhost:9650")!, network: .local) // connects to localhost with network id 12345
let xchain = ava.XChain // returns a reference to the X-Chain instance in current Avalanche
```
### Accessing the KeyChain

The KeyChain is accessed through the X-Chain and can be referenced directly or through a reference variable.

```Swift
let keychain = xchain.keychain;
```

This exposes the instance of the In-App Keychain which is created when the X-Chain API is created. At present, this supports secp256k1 curve for ECDSA key pairs.

### Creating X-Chain key pairs

The In-App KeyChain has the ability to create new KeyPairs for you and return the address assocated with the key pair. `mutate` method will allow mutating of In-App Keychain.

```Swift
let newAddress1 = try keychain.mutate() { mutator in
    mutator.newKey() //returns an AvalancheAddress object
}
print("Address", newAddress1.bech32) //will print Bech32 encoded address
```

You may also import your exsting private key into the KeyChain using either a Buffer...

```Swift
let mypk = try Data(cb58: "24jUJ9vZexUM6expyMcT48LBx27k1m7xpraoV62oSQAHdziao5") //initializes Data object
let newAddress2 = try keychain.mutate() { mutator in
    mutator.importKey(pk: mypk) //returns an AvalancheAddress object
}
```
... or an Avalanche serialized string works, too:

```Swift
let mypk = "24jUJ9vZexUM6expyMcT48LBx27k1m7xpraoV62oSQAHdziao5"
let newAddress2 = try keychain.mutate() { mutator in
    mutator.importKey(cb58: mypk) //returns an AvalancheAddress object
}
```

### Working with KeyChains

The X-Chains's KeyChain has standardized key management capabilities. The following functions are available on any KeyChain that implements this interface.

```Swift
// obtaining list of addresses
keychain.addresses() { result in
    switch result {
    case .success(let addresses): print("Addresses", addresses) //list of AvalancheAddress objects
    case .failure(let error): print("Error", error) //some error
    }
}

// signing message
let message = Data(repeating: 0, count: 20)
keychain.sign(message: message, address: newAddress1) { result in
    switch result {
    case .success(let signature): print("Signature", signature) //Data object with signature
    case .failure(let error): print("Error", error) //some error
    }
}

// verifying signature
let message = Data(repeating: 0, count: 20)
let signature = Data(repeating: 0, count: 20)
keychain.verify(message: message, signature: signature, address: newAddress2) { result in
    switch result {
    case .success(let signed): print("Signed?", signed) //Bool value
    case .failure(let error): print("Error", error) //some error
    }
}
```

## License

Avalanche.swift can be used, distributed and modified under [the Apache 2.0 license](LICENSE).
