//
//  SHA256.swift
//  
//
//  Created by Daniel Leping on 09/01/2021.
//

import Foundation

import CryptoSwift

extension Base58 {
    /// Create a sha256 hash of the given data.
    /// - Parameter data: Input data to hash.
    /// - Returns: A sha256 hash of the input data.
    static func sha256(_ data: [UInt8]) -> [UInt8] {
        SHA2(variant: .sha256).calculate(for: data)
    }
}
