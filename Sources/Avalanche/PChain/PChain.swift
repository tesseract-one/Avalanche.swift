//
//  PChain.swift
//  
//
//  Created by Yehor Popovych on 10/4/20.
//

import Foundation
import BigInt
//import RPC

public class AvalanchePChainApiInfo: AvalancheBaseApiInfo {
    public let txFee: BigUInt
    public let creationTxFee: BigUInt
    public let minConsumption: Double
    public let maxConsumption: Double
    public let maxStakingDuration: BigUInt
    public let maxSupply: BigUInt
    public let minStake: BigUInt
    public let minStakeDuration: UInt
    public let maxStakeDuration: UInt
    public let minDelegationStake: BigUInt
    public let minDelegationFee: BigUInt
    
    public init(
        minConsumption: Double, maxConsumption: Double, maxStakingDuration: BigUInt,
        maxSupply: BigUInt, minStake: BigUInt, minStakeDuration: UInt,
        maxStakeDuration: UInt, minDelegationStake: BigUInt, minDelegationFee: BigUInt,
        txFee: BigUInt, creationTxFee: BigUInt, bId: String,
        alias: String? = nil, vm: String = "platformvm"
    ) {
        self.minConsumption = minConsumption; self.maxConsumption = maxConsumption
        self.maxStakingDuration = maxStakingDuration; self.maxSupply = maxSupply
        self.minStake = minStake; self.minStakeDuration = minStakeDuration
        self.maxStakeDuration = maxStakeDuration; self.minDelegationStake = minDelegationStake
        self.minDelegationFee = minDelegationFee; self.txFee = txFee; self.creationTxFee = creationTxFee
        super.init(bId: bId, alias: alias, vm: vm)
    }
    
    override public var apiPath: String {
        return "/ext/\(alias ?? blockchainId)"
    }
}

public struct AvalanchePChainApi: AvalancheApi {
    public typealias Info = AvalanchePChainApiInfo
    
    public let keychain: Keychain
    //FIX: private let network: AvalancheRpcConnection
    
    public init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: Info) {
        //FIX: self.network = avalanche.connections.httpRpcConnection(for: info.apiPath)
        self.keychain = avalanche.keychain
    }
}

extension AvalancheCore {
    public var PChain: AvalanchePChainApi {
        return try! self.getAPI()
    }
    
    public func PChain(network: AvalancheNetwork, hrp: String, info: AvalanchePChainApi.Info) -> AvalanchePChainApi {
        return self.createAPI(network: network, hrp: hrp, info: info)
    }
}
