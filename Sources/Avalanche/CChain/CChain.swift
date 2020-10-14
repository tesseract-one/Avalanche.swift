//
//  CChain.swift
//  
//
//  Created by Yehor Popovych on 10/14/20.
//

import Foundation
import BigInt

public class AvalancheCChainApiInfo: AvalancheBaseApiInfo {
    public let gasPrice: BigUInt
    public let chainId: UInt32
    
    public init(
        gasPrice: BigUInt, chainId: UInt32, bId: String,
        alias: String? = nil, vm: String = "evm"
    ) {
        self.gasPrice = gasPrice
        self.chainId = chainId
        super.init(bId: bId, alias: alias, vm: vm)
    }
    
    override var apiPath: String {
        return super.apiPath + "/rpc"
    }
    
    public var wsApiPath: String {
        return super.apiPath + "/ws"
    }
}

public class AvalancheCChainApi: AvalancheApi {
    public typealias Info = AvalancheCChainApiInfo
    
    private let network: AvalancheRpcConnection
    public let keychain: AvalancheEthereumKeychain
    
    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: Info) {
        self.network = avalanche.connections.wsRpcConnection(for: info.wsApiPath)
        self.keychain = avalanche.keychains.avaEthereumKeychain(network: network, chainId: info.chainId)
    }
}

extension AvalancheCore {
    public var CChain: AvalancheCChainApi {
        return try! self.getAPI()
    }
    
    public func CChain(network: AvalancheNetwork, hrp: String, info: AvalancheCChainApi.Info) -> AvalancheCChainApi {
        return AvalancheCChainApi(avalanche: self, network: network, hrp: hrp, info: info)
    }
}
