//
//  NetworkInfo.swift
//  
//
//  Created by Yehor Popovych on 10/14/20.
//

import Foundation

public protocol AvalancheApiInfoProvider {
    func info<A: AvalancheApi>(for: A.Type) -> A.Info?
    func setInfo<A: AvalancheApi>(info: A.Info, for: A.Type)
}

public protocol AvalancheNetworkInfo {
    var hrp: String { get }
    var apiInfo: AvalancheApiInfoProvider { get }
}

public protocol AvalancheNetworkInfoProvider {
    func info(for net: AvalancheNetwork) -> AvalancheNetworkInfo?
    func setInfo(info: AvalancheNetworkInfo, for net: AvalancheNetwork)
}

public class AvalancheDefaultApiInfoProvider: AvalancheApiInfoProvider {
    private var infos: Dictionary<String, AvalancheApiInfo>
    
    public init(infos: Dictionary<String, AvalancheApiInfo> = [:]) {
        self.infos = infos
    }
    
    public func info<A: AvalancheApi>(for: A.Type) -> A.Info? {
        return infos[A.id] as? A.Info
    }
    
    public func setInfo<A: AvalancheApi>(info: A.Info, for: A.Type) {
        infos[A.id] = info
    }
}

public class AvalancheDefaultNetworkInfo: AvalancheNetworkInfo {
    public let hrp: String
    public let apiInfo: AvalancheApiInfoProvider
    
    public init(hrp: String, apiInfo: AvalancheApiInfoProvider) {
        self.hrp = hrp
        self.apiInfo = apiInfo
    }
}

public class AvalancheDefaultNetworkInfoProvider: AvalancheNetworkInfoProvider {
    private var infos: Dictionary<AvalancheNetwork, AvalancheNetworkInfo>
    
    public init(infos: Dictionary<AvalancheNetwork, AvalancheNetworkInfo> = [:]) {
        self.infos = infos
    }
    
    public func info(for net: AvalancheNetwork) -> AvalancheNetworkInfo? {
        return infos[net]
    }
    
    public func setInfo(info: AvalancheNetworkInfo, for net: AvalancheNetwork) {
        infos[net] = info
    }
    
    public static let `default`: AvalancheNetworkInfoProvider = {
        // TODO: Fill Network Info table. Example in JS
        let provider = AvalancheDefaultNetworkInfoProvider()
        
        // AvalancheNetwork.main || AvalancheNetwork.avalanche
        let netAvaApis = AvalancheDefaultApiInfoProvider()
        netAvaApis.setInfo(
            info: AvalancheXChainApi.Info(
                txFee: .milliAVAX,
                creationTxFee: .centiAVAX,
                bId: "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM",
                alias: "X"
            ),
            for: AvalancheXChainApi.self
        )
        netAvaApis.setInfo(
            info: AvalancheCChainApi.Info(
                gasPrice: 470.gwei,
                chainId: 43114,
                bId: "2q9e4r6Mu3U68nU1fYjgbR6JvwrRx36CohpAX5UQxse55x1Q5",
                alias: "C"
            ),
            for: AvalancheCChainApi.self
        )
        netAvaApis.setInfo(
            info: AvalanchePChainApi.Info(
                minConsumption: 0.1,
                maxConsumption: 0.12,
                maxStakingDuration: 31536000,
                maxSupply: 720000000.AVAX,
                minStake: 2000.AVAX,
                minStakeDuration: 2 * 7 * 24 * 60 * 60, //two weeks
                maxStakeDuration: 365 * 24 * 60 * 60, // one year
                minDelegationStake: 25.AVAX,
                minDelegationFee: 2.AVAX,
                txFee: .milliAVAX,
                creationTxFee: .centiAVAX,
                bId: "11111111111111111111111111111111LpoYY",
                alias: "P"
            ),
            for: AvalanchePChainApi.self
        )
        let netAvalanche = AvalancheDefaultNetworkInfo(hrp: "avax", apiInfo: netAvaApis)
        provider.setInfo(info: netAvalanche, for: .avalanche)
        
        return provider
    }()
}
