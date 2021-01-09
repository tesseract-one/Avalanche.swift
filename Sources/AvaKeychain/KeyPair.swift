//
//  File.swift
//  
//
//  Created by Daniel Leping on 09/01/2021.
//

import Foundation

import Avalanche
import AvaAlgos
import Base58

public struct KeyPair {
    public let priv: Data
    public let pub: Data
}

public extension KeyPair {
    init?(priv: Data) {
        guard let pub = SECP256K1.privateToPublic(privateKey: priv) else {
            return nil
        }
        
        self.init(priv: priv, pub: pub)
    }
    
    /// import from string
    init?(key: String) {
        let parts = key.split(separator: "-")
        
        guard parts.count == 2 else {
            return nil
        }
        
        guard parts[0] == "PrivateKey" else {
            return nil
        }
        
        guard let pk = Base58.base58CheckDecode(String(parts[1])) else {
            return nil
        }
        
        self.init(priv: Data(pk))
    }
    
    var address: Address {
        Address(pub: pub)
    }
    
    func signAva(data: Data) -> Data? {
        Avalanche.sign(data: data, with: priv)
    }
    
    func signEth(data: Data) -> Data? {
        Ethereum.sign(data: data, with: priv)
    }
    
    var privateString: String {
        "PrivateKey-" + Base58.base58CheckEncode(priv.bytes)
    }
    
    var publicString: String {
        Base58.base58CheckEncode(pub.bytes)
    }
    
    static func generate() -> KeyPair? {
        SECP256K1.generateKey().flatMap(KeyPair.init)
    }
}
