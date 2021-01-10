//
//  File.swift
//  
//
//  Created by Daniel Leping on 08/01/2021.
//

import Foundation
#if !COCOAPODS
import AvalancheAlgos
#endif

public enum AddressError: Error {
    case bech(error: Bech32Error)
    case malformed(address: String, description: String)
}

public protocol BechAddress {
    var bech: String {get}
}

public protocol EthAddress {
    var eth: String {get}
}

public struct Address {
    public let pub: Data
    
    public init(pub: Data) {
        self.pub = pub
    }
}

extension Address: Hashable {
    public func hash(into hasher: inout Hasher) {
        pub.hash(into: &hasher)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.pub == rhs.pub
    }
}

extension Address: EthAddress {
    public var eth: String {
        Ethereum.hexAddress(pub: pub, eip55: false) ?? "internal error" //eip55 is false for AVA, I guess. Internal error should never happen at this point, uless it's an improper key
    }
}


