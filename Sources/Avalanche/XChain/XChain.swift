//
//  XChain.swift
//  
//
//  Created by Yehor Popovych on 10/14/20.
//

import Foundation
import BigInt
//import RPC

public class AvalancheXChainApiInfo: AvalancheBaseApiInfo {
    public let txFee: BigUInt
    public let creationTxFee: BigUInt
    
    public init(
        txFee: BigUInt, creationTxFee: BigUInt, bId: String,
        alias: String? = nil, vm: String = "avm"
    ) {
        self.txFee = txFee
        self.creationTxFee = creationTxFee
        super.init(bId: bId, alias: alias, vm: vm)
    }
    
    public var vmApiPath: String {
        return "/ext/vm/\(vm)"
    }
}

public class AvalancheXChainApi: AvalancheApi {
    public typealias Info = AvalancheXChainApiInfo
    
    //FIX: private let network: AvalancheRpcConnection
    //FIX: private let vmNetwork: AvalancheRpcConnection
    public let keychain: Keychain
    
    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: Info) {
        //FIX: self.network = avalanche.connections.httpRpcConnection(for: info.apiPath)
        //FIX: self.vmNetwork = avalanche.connections.httpRpcConnection(for: info.vmApiPath)
        self.keychain = avalanche.keychain
    }
}

extension AvalancheCore {
    public var XChain: AvalancheXChainApi {
        return try! self.getAPI()
    }
    
    public func XChain(network: AvalancheNetwork, hrp: String, info: AvalancheXChainApi.Info) -> AvalancheXChainApi {
        return self.createAPI(network: network, hrp: hrp, info: info)
    }
}
