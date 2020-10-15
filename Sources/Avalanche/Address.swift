//
//  Address.swift
//  
//
//  Created by Yehor Popovych on 10/14/20.
//

import Foundation
#if !COCOAPODS
import Bech32
#endif

// TODO: Implement Address structure
public struct AvalancheAddress {
    public let address: Data
    public let chainId: String?
    public let hrp: String?
    
    public init(address: Data, hrp: String, chainId: String) {
        self.address = address
        self.hrp = hrp
        self.chainId = chainId
    }
    
    public init(b32: String) throws {
        let parts = b32.split(separator: "-")
        self.chainId = parts.count == 2 ? String(parts[0]) : nil
        let bech32Str = parts.count == 2 ? String(parts[1]) : String(parts[0])
        let (hrp, bytes) = try Self.bech32.decode(bech32Str)
        self.address = try Self.segWit.convertBits(from: 5, to: 8, pad: false, idata: bytes)
        self.hrp = hrp
    }
    
    public var bech32: String? {
        guard let hrp = hrp, let chainId = chainId else {
            return nil
        }
        guard let bytes = try? Self.segWit.convertBits(from: 8, to: 5, pad: true, idata: address) else {
            return nil
        }
        let b32 = Self.bech32.encode(hrp, values: bytes)
        return "\(chainId)-\(b32)"
    }
    
    private static let bech32 = Bech32()
    private static let segWit = SegwitAddrCoder()
}
