//
//  File.swift
//  
//
//  Created by Daniel Leping on 07/01/2021.
//

import Foundation

public enum KeychainError: Error {
    case avaAddressNotFound(address: AvaAddress)
    case avaCantSign(data: Data, address: AvaAddress)
    
    case ethAddressNotFound(address: EthAddress)
    case ethCantSign(data: Data, address: EthAddress)
    
    case unknown
}

public protocol Keychain {
    func addresses(result: (Result<Addresses, KeychainError>)->Void)
    
    func sign(data: Data, by: [UniAddress], result: (Result<[UniAddress: Data], KeychainError>)->Void)
    
    func signAva(data: Data, by: [AvaAddress], result: (Result<[AvaAddress: Data], KeychainError>)->Void)
    func signEth<Addr: EthAddress>(data: Data, by: [Addr], result: (Result<[Addr: Data], KeychainError>)->Void) where Addr: Hashable
}

public enum EmptyKeychain {
    case empty
}

extension EmptyKeychain: Keychain {
    public func addresses(result: (Result<Addresses, KeychainError>) -> Void) {
        result(.success(Addresses(xMain: [], xChange: [], pMain: [], pChange: [], c: [])))
    }
    
    public func sign(data: Data, by addresses: [UniAddress], result: (Result<[UniAddress : Data], KeychainError>) -> Void) {
        guard !addresses.isEmpty else {
            result(.success([:]))
            return
        }
        switch addresses[0] {
        case .bech(let address):
            result(.failure(.avaAddressNotFound(address: address)))
        case .eth(let address):
            result(.failure(.ethAddressNotFound(address: address)))
        }
    }
    
    public func signAva(data: Data, by addresses: [AvaAddress], result: (Result<[AvaAddress : Data], KeychainError>) -> Void) {
        guard !addresses.isEmpty else {
            result(.success([:]))
            return
        }
        
        result(.failure(.avaAddressNotFound(address: addresses[0])))
    }
    
    public func signEth<Addr>(data: Data, by addresses: [Addr], result: (Result<[Addr : Data], KeychainError>) -> Void) where Addr : EthAddress, Addr : Hashable {
        guard !addresses.isEmpty else {
            result(.success([:]))
            return
        }
        
        result(.failure(.ethAddressNotFound(address: addresses[0])))
    }
}
