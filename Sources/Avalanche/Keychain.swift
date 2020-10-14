//
//  Keychain.swift
//  
//
//  Created by Yehor Popovych on 10/4/20.
//

import Foundation

public enum AvalancheKeychainError: Error {
    case badAddressString(address: String, error: Error)
    case pubKeyNotFound(key: Data)
}

public typealias AvalancheKeychainCallback<R> = AvalancheResponseCallback<R, AvalancheKeychainError>

public protocol AvalancheKeychain {
    func parseAddress(address: String) -> Data
    func pubKeys(response: @escaping AvalancheKeychainCallback<[Data]>)
    func sign(message: Data, pubKey: Data, response: @escaping AvalancheKeychainCallback<Data>)
    func verify(message: Data, pubKey: Data, response: @escaping AvalancheKeychainCallback<Bool>)
}

public enum AvalancheKeychainType {
    case secp256k1
}

public protocol AvalancheKeychainFactory {
    func keychain(type: AvalancheKeychainType, prefix: Data) -> AvalancheKeychain
}
