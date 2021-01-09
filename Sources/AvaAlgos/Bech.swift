//
//  File.swift
//  
//
//  Created by Daniel Leping on 08/01/2021.
//

import Foundation

import Bech32

public enum Bech32Error: Error {
    case chainIdEmpty(address: String)
    case bechEmpty(address: String)
    case bech(address: String, cause: Error)
    case segwitDecode(address: String, cause: Error)
    case segwitEncode(data: Data, hrp: String, chainId: String, cause: Error)
}

private let bech32 = Bech32()
private let segWit = SegwitAddrCoder()

public enum Bech {
    public static func parse(address: String) -> Result<(Data, String, String), Bech32Error> { //data, hrp, chainid
        let parts = address.split(separator: "-")
        guard let chainId = parts.count > 0 ? String(parts[0]) : nil else {
            return .failure(.chainIdEmpty(address: address))
        }
        guard let bech32Str = parts.count == 2 ? String(parts[1]) : nil else {
            return .failure(.bechEmpty(address: address))
        }
        
        return Result {
            try bech32.decode(bech32Str)
        }.mapError { e in
            Bech32Error.bech(address: address, cause: e)
        }.flatMap { hrp, bytes in
            Result {
                let address = try segWit.convertBits(from: 5, to: 8, pad: false, idata: bytes)
                return (address, hrp, chainId)
            }.mapError { e in
                .segwitDecode(address: address, cause: e)
            }
        }
    }

    public static func address(from data: Data, hrp: String, chainId: String) -> Result<String, Bech32Error> {
        Result {
            let bytes = try segWit.convertBits(from: 8, to: 5, pad: true, idata: data)
            let b32 = bech32.encode(hrp, values: bytes)
            return "\(chainId)-\(b32)"
        }.mapError { e in
            .segwitEncode(data: data, hrp: hrp, chainId: chainId, cause: e)
        }
    }
}
