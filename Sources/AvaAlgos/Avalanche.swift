//
//  File.swift
//  
//
//  Created by Daniel Leping on 09/01/2021.
//

import Foundation

public enum Avalanche {
    public static func sign(data: Data, with key: Data) -> Data? {
        SECP256K1.sign(data: data.bytes, with: key)
    }
}
