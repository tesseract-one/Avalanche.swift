//
//  Ethereum.swift
//  
//
//  Created by Daniel Leping on 09/01/2021.
//

import Foundation

import CryptoSwift

public enum Ethereum {
    public static func sign(data: Data, with key: Data) -> Data? {
        let hash = SHA3(variant: .keccak256).calculate(for: data.bytes)
        
        guard hash.count == 32 else {
            return nil
        }
        
        return SECP256K1.sign(data: hash, with: key)
    }
    
    static func address(from pub: Data) -> Data? {
        guard var parsed = SECP256K1.parsePublicKey(serializedKey: pub) else { return nil }
        guard var mPubKey = SECP256K1.serializePublicKey(publicKey: &parsed, compressed: false)?.bytes else { return nil }
        mPubKey.remove(at: 0)
        let hash = SHA3(variant: .keccak256).calculate(for: mPubKey)
        guard hash.count == 32 else {
            return nil
        }
        return Data(hash[12...])
    }
    
    private static let hexadecimalNumbers: CharacterSet = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    private static let hexadecimalLettersLower: CharacterSet = ["a", "b", "c", "d", "e", "f"]
    private static let hexadecimalCharsLower: CharacterSet = hexadecimalNumbers.union(hexadecimalLettersLower)
    
    public static func hexAddress(pub: Data, eip55: Bool) -> String? {
        guard let rawAddress = Self.address(from: pub)?.bytes else {
            return nil
        }
        var hex = "0x"
        if !eip55 {
            for b in rawAddress {
                hex += String(format: "%02x", b)
            }
        } else {
            var address = ""
            for b in rawAddress {
                address += String(format: "%02x", b)
            }
            let hash = SHA3(variant: .keccak256).calculate(for: Array(address.utf8))
            
            for i in 0..<address.count {
                let charString = String(address[address.index(address.startIndex, offsetBy: i)])
                
                if charString.rangeOfCharacter(from: hexadecimalNumbers) != nil {
                    hex += charString
                    continue
                }
                
                let bytePos = (4 * i) / 8
                let bitPos = (4 * i) % 8
                let bit = (hash[bytePos] >> (7 - UInt8(bitPos))) & 0x01
                
                if bit == 1 {
                    hex += charString.uppercased()
                } else {
                    hex += charString.lowercased()
                }
            }
        }
        
        return hex
    }
    
    public static func valid(address: String) -> Bool {
        let parts = address.split(separator: "x")
        return parts.count == 2 &&
            parts[0] == "0" &&
            parts[1].count <= 40 &&
            parts[1].lowercased().consistsOnlyOf(chars: hexadecimalCharsLower)
    }
}

extension StringProtocol {
    func consistsOnlyOf(chars: CharacterSet) -> Bool {
        self.reduce(true) { ok, char in
            guard ok else {
                return false
            }
            return char.unicodeScalars.map { scalar in
                chars.contains(scalar)
            }.reduce(true) { ok, elementOk in
                guard ok else {
                    return false
                }
                return elementOk
            }
        }
    }
}
