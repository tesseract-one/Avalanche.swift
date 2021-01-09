//
//  File.swift
//  
//
//  Created by Daniel Leping on 09/01/2021.
//

import Foundation

import Avalanche

public class AvaKeychain {
    private var _x_main = [KeyPair]()
    private var _x_change = [KeyPair]()
    private var _p_main = [KeyPair]()
    private var _p_change = [KeyPair]()
    private var _c = [KeyPair]()
    
    private var _pub_cache = [Address: KeyPair]()
    private var _eth_cache = [String: KeyPair]()
}

extension AvaKeychain: Keychain {
    private static func _address(_ pair: KeyPair) -> Address {
        pair.address
    }
    
    public func addresses(result: (Result<Addresses, KeychainError>)->Void) {
        result(.success(Addresses(xMain: _x_main.map(AvaKeychain._address),
                                  xChange: _x_change.map(AvaKeychain._address),
                                  pMain: _p_main.map(AvaKeychain._address),
                                  pChange: _p_change.map(AvaKeychain._address),
                                  c: _c.map(AvaKeychain._address))))
    }
    
    private func signAva(data: Data, single address: AvaAddress) -> Result<Data, KeychainError> {
        guard let key = _pub_cache[address.address] else {
            return .failure(.avaAddressNotFound(address: address))
        }
        guard let sig = key.signAva(data: data) else {
            return .failure(.avaCantSign(data: data, address: address))
        }
        
        return .success(sig)
    }
    
    private func signEth(data: Data, single address: EthAddress) -> Result<Data, KeychainError> {
        guard let key = _eth_cache[address.eth] else {
            return .failure(.ethAddressNotFound(address: address))
        }
        guard let sig = key.signEth(data: data) else {
            return .failure(.ethCantSign(data: data, address: address))
        }
        
        return .success(sig)
    }
    
    private func sign(data: Data, single address: UniAddress) -> Result<Data, KeychainError> {
        switch address {
        case .bech(let aa):
            return signAva(data: data, single: aa)
        case .eth(let ea):
            return signEth(data: data, single: ea)
        }
    }
    
    private func processSigResults<Addr: Hashable>(_ sigsr: [Result<(Addr, Data), KeychainError>]) -> Result<[Addr: Data], KeychainError> {
        let errors: [KeychainError] = sigsr.compactMap { r in
            switch r {
                case .failure(let e): return e
                case .success(_): return nil
            }
        }
        
        if let e = errors.first {
            return .failure(e)
        }
        
        let sigs: [(Addr, Data)] = sigsr.compactMap { r in
            switch r {
                case .success(let s): return s
                case .failure(_): return nil
            }
        }
        
        guard sigs.count == sigsr.count else {
            return .failure(.unknown)
        }
        
        return .success(sigs.reduce(into: [:]) { $0[$1.0] = $1.1 })
    }
    
    public func sign(data: Data, by addresses: [UniAddress], result: (Result<[UniAddress: Data], KeychainError>)->Void) {
        let sigsr:[Result<(UniAddress, Data), KeychainError>] = addresses.map { ua in
            sign(data: data, single: ua).map {(ua, $0)}
        }
        
        result(processSigResults(sigsr))
    }
    
    public func signAva(data: Data, by addresses: [AvaAddress], result: (Result<[AvaAddress: Data], KeychainError>)->Void) {
        let sigsr:[Result<(AvaAddress, Data), KeychainError>] = addresses.map { aa in
            signAva(data: data, single: aa).map {(aa, $0)}
        }
        
        result(processSigResults(sigsr))
    }
    
    public func signEth<Addr: EthAddress>(data: Data, by addresses: [Addr], result: (Result<[Addr: Data], KeychainError>)->Void) where Addr: Hashable {
        let sigsr:[Result<(Addr, Data), KeychainError>] = addresses.map { ea in
            signEth(data: data, single: ea).map {(ea, $0)}
        }
        
        result(processSigResults(sigsr))
    }
}

extension AvaKeychain {
    func addXKey(key: KeyPair, change: Bool = false) {
        if change {
            _x_change.append(key)
        } else {
            _x_main.append(key)
        }
        _pub_cache[key.address] = key
    }
    
    func addPKey(key: KeyPair, change: Bool = false) {
        if change {
            _p_change.append(key)
        } else {
            _p_main.append(key)
        }
        _pub_cache[key.address] = key
    }
    
    func addCKey(key: KeyPair) {
        _c.append(key)
        
        let address = key.address
        
        _pub_cache[address] = key
        _eth_cache[address.eth] = key
    }
}
