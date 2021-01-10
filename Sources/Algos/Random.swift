//
//  Random.swift
//  
//
//  Created by Yehor Popovych on 1/10/21.
//

import Foundation

public enum AvalancheSecureRandomError: Error {
    case rndError(String)
}

public protocol AvalancheSecureRandomBytes: DataProtocol {
    static func secureRandom(bytes: UInt8) throws -> Self
}

extension Data: AvalancheSecureRandomBytes {
    public static func secureRandom(bytes: UInt8) throws -> Data {
        return try Data(Array.secureRandom(bytes: bytes))
    }
}

#if os(Linux)
import Glibc

extension Array: AvalancheSecureRandomBytes where Element == UInt8 {
    public static func secureRandom(bytes: UInt8) throws -> Array<UInt8> {
        var result = Array<UInt8>(repeating: 0, count: Int(bytes))
        guard getentropy(&result, result.count) == 0 else {
            throw AvalancheSecureRandomError.rndError("Can't obtain \(bytes) bytes of random data")
        }
        return result
    }
}

#else
import Security

extension Array: AvalancheSecureRandomBytes where Element == UInt8 {
    public static func secureRandom(bytes: UInt8) throws -> Array<UInt8> {
        var result = Array<UInt8>(repeating: 0, count: Int(bytes))
        guard SecRandomCopyBytes(kSecRandomDefault, result.count, &result) == 0 else {
            throw AvalancheSecureRandomError.rndError("Can't obtain \(bytes) bytes of random data")
        }
        return result
    }
}

#endif
