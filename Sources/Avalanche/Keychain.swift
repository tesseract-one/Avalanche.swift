//
//  Keychain.swift
//  
//
//  Created by Yehor Popovych on 10/4/20.
//

import Foundation

public enum AvalancheKeychainError: Error {
    case addressNotFound(AvalancheAddress)
}

public typealias AvalancheKeychainCallback<R> = AvalancheResponseCallback<R, AvalancheKeychainError>

public protocol AvalancheKeychain {
    func addresses(response: @escaping AvalancheKeychainCallback<[AvalancheAddress]>)
    func sign(
        message: Data, address: AvalancheAddress,
        response: @escaping AvalancheKeychainCallback<Data>
    )
    func verify(
        message: Data, signature: Data, address: AvalancheAddress,
        response: @escaping AvalancheKeychainCallback<Bool>
    )
    
    func mutate<R>(mutator: @escaping (AvalancheKeychainMutator) throws -> R) throws -> R
}

public protocol AvalancheEthereumKeychain {
    func addresses(response: @escaping AvalancheKeychainCallback<[Data]>)
    func sign(
        message: Data, address: Data,
        response: @escaping AvalancheKeychainCallback<Data>
    )
    
    func signTx(
        tx: Any, address: Data,
        response: @escaping AvalancheKeychainCallback<Data>
    )
    
    func signTypedData(
        tx: Any, address: Data,
        response: @escaping AvalancheKeychainCallback<Data>
    )
    
    func verify(
        message: Data, signature: Data, address: Data,
        response: @escaping AvalancheKeychainCallback<Bool>
    )
    
    func mutate<R>(mutator: @escaping (AvalancheEthereumKeychainMutator) throws -> R) throws -> R
}

public protocol AvalancheKeychainMutator {
    func newKey() -> AvalancheAddress
    func importKey(pk: Data) -> AvalancheAddress
    func exportKey(for address: AvalancheAddress) -> Data
}

public protocol AvalancheEthereumKeychainMutator {
    func newKey() -> Data
    func importKey(pk: Data) -> Data
    func exportKey(for address: Data) -> Data
}

public protocol AvalancheKeychainFactory {
    func avaSecp256k1Keychain(hrp: String, chainId: String, chainAlias: String?) -> AvalancheKeychain
    func avaEthereumKeychain(network: AvalancheNetwork, chainId: UInt32) -> AvalancheEthereumKeychain
}
