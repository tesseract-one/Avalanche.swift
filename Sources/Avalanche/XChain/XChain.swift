//
//  XChain.swift
//  
//
//  Created by Yehor Popovych on 10/14/20.
//

import Foundation
import BigInt

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
    
    private let network: AvalancheRpcConnection
    private let vmNetwork: AvalancheRpcConnection
    
    public required init(avalanche: AvalancheCore, info: Info) {
        self.network = avalanche.connections.httpRpcConnection(for: info.apiPath)
        self.vmNetwork = avalanche.connections.httpRpcConnection(for: info.vmApiPath)
    }
}

extension AvalancheCore {
    public var XChain: AvalancheXChainApi {
        return try! self.getAPI()
    }
    
    public func XChain(info: AvalancheXChainApi.Info) -> AvalancheXChainApi {
        return AvalancheXChainApi(avalanche: self, info: info)
    }
}
