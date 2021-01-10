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

private struct EthAddressNoPub {
    public let eth: String
}

extension EthAddressNoPub: EthAddress {
}

public enum UniAddress {
    case eth(_: EthAddress)
    case bech(_: AvaAddress)
}

extension UniAddress: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .eth(let ea):
            ea.eth.hash(into: &hasher)
        case .bech(let aa):
            aa.hash(into: &hasher)
        }
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case .eth(let lea):
            switch rhs {
            case .eth(let rea):
                return lea.eth == rea.eth
            case .bech(_):
                return false
            }
        case .bech(let laa):
            switch rhs {
            case .eth(_):
                return false
            case .bech(let raa):
                return laa == raa
            }
        }
    }
}

extension UniAddress: EthAddress {
    public var eth: String {
        switch self {
        case .bech(let ava):
            return ava.eth
        case .eth(let eth):
            return eth.eth
        }
    }
}

public extension UniAddress {
    func from(string: String) -> Result<UniAddress, AddressError> {
        guard !Ethereum.valid(address: string) else {
            return .success(.eth(EthAddressNoPub(eth: string)))
        }
        
        return AvaAddress.from(bech: string)
            .map(UniAddress.bech)
            .mapError(AddressError.bech)
    }
}
