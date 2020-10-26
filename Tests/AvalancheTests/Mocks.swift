//
//  File.swift
//  
//
//  Created by Yehor Popovych on 10/15/20.
//

import XCTest
import Avalanche

class MockAvalancheKeychain: AvalancheKeychain {
    func addresses(response: @escaping AvalancheKeychainCallback<[AvalancheAddress]>) {
    }
    
    func sign(message: Data, address: AvalancheAddress, response: @escaping AvalancheKeychainCallback<Data>) {
    }
    
    func signTx(tx: Any, address: AvalancheAddress, response: @escaping AvalancheKeychainCallback<Any>) {
    }
    
    func verify(message: Data, signature: Data, address: AvalancheAddress, response: @escaping AvalancheKeychainCallback<Bool>) {
    }
    
    func mutate<R>(mutator: @escaping (AvalancheKeychainMutator) throws -> R) throws -> R {
        fatalError()
    }
}

class MockAvalancheEthereumKeychain: AvalancheEthereumKeychain {
    func addresses(response: @escaping AvalancheKeychainCallback<[Data]>) {
    }
    
    func sign(message: Data, address: Data, response: @escaping AvalancheKeychainCallback<Data>) {
    }
    
    func signTx(tx: Any, address: Data, response: @escaping AvalancheKeychainCallback<Data>) {
    }
    
    func signTypedData(tx: Any, address: Data, response: @escaping AvalancheKeychainCallback<Data>) {
    }
    
    func verify(message: Data, signature: Data, address: Data, response: @escaping AvalancheKeychainCallback<Bool>) {
    }
    
    func mutate<R>(mutator: @escaping (AvalancheEthereumKeychainMutator) throws -> R) throws -> R {
        fatalError()
    }
    
    
}

class MockKeychainFactory: AvalancheKeychainFactory {
    func avaSecp256k1Keychain(hrp: String, chainId: String, chainAlias: String?) -> AvalancheKeychain {
        return MockAvalancheKeychain()
    }
    
    func avaEthereumKeychain(network: AvalancheNetwork, chainId: UInt32) -> AvalancheEthereumKeychain {
        return MockAvalancheEthereumKeychain()
    }
    
    
}
