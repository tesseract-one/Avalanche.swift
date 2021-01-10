//
//  File.swift
//  
//
//  Created by Daniel Leping on 09/01/2021.
//

import Foundation
#if !COCOAPODS
import AvalancheAlgos
#endif

public struct AvaAddress {
    public let address: Address
    let hrp: String
    let chain: String
    
    public let bech: String
}

extension AvaAddress: BechAddress {
}

extension AvaAddress: Hashable {
    public func hash(into hasher: inout Hasher) {
        bech.hash(into: &hasher)
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.bech == rhs.bech
    }
}

public extension AvaAddress {
    static func from(address: Address, hrp: String, chain: String) -> Result<AvaAddress, Bech32Error> {
        Bech.address(from: address.pub, hrp: hrp, chainId: chain).map { bech in
            AvaAddress(address: address, hrp: hrp, chain: chain, bech: bech)
        }
    }
    
    static func from(bech: String) -> Result<AvaAddress, Bech32Error> {
        Bech.parse(address: bech).map { data, hrp, chain in
            AvaAddress(address: Address(pub: data), hrp: hrp, chain: chain, bech: bech)
        }
    }
}

public extension Address {
    func ava(hrp: String, chain: String) -> Result<AvaAddress, Bech32Error> {
        AvaAddress.from(address: self, hrp: hrp, chain: chain)
    }
}

extension AvaAddress: EthAddress {
    public var eth: String {
        address.eth
    }
}
