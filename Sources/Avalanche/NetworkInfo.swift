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
        // TODO: Fill Network Info table.
        // Example in JS:
        // https://github.com/ava-labs/avalanchejs/blob/master/src/utils/constants.ts
        let provider = AvalancheDefaultNetworkInfoProvider()
        
        // AvalancheNetwork.manhattan
        provider.setInfo(info: manhattanNetInfo(), for: .manhattan)
        // AvalancheNetwork.main || AvalancheNetwork.avalanche
        provider.setInfo(info: avalancheNetInfo(), for: .avalanche)
        // AvalancheNetwork.test || AvalancheNetwork.fuji
        provider.setInfo(info: fujiNetInfo(), for: .fuji)
        
        return provider
    }()
    
    private static func addNonVmApis(to info: AvalancheDefaultApiInfoProvider) {
        info.setInfo(info: AvalancheInfoApiInfo(), for: AvalancheInfoApi.self)
        info.setInfo(info: AvalancheHealthApiInfo(), for: AvalancheHealthApi.self)
        info.setInfo(info: AvalancheMetricsApiInfo(), for: AvalancheMetricsApi.self)
        info.setInfo(info: AvalancheAdminApiInfo(), for: AvalancheAdminApi.self)
        info.setInfo(info: AvalancheAuthApiInfo(), for: AvalancheAuthApi.self)
        info.setInfo(info: AvalancheIPCApiInfo(), for: AvalancheIPCApi.self)
    }
    
    // AvalancheNetwork.manhattan
    private static func manhattanNetInfo() -> AvalancheDefaultNetworkInfo {
        let netApis = AvalancheDefaultApiInfoProvider()
        addNonVmApis(to: netApis)
        netApis.setInfo(
            info: AvalancheXChainApi.Info(
                txFee: .milliAVAX,
                creationTxFee: .centiAVAX,
                bId: "2vrXWHgGxh5n3YsLHMV16YVVJTpT4z45Fmb4y3bL6si8kLCyg9",
                alias: "X"
            ),
            for: AvalancheXChainApi.self
        )
        netApis.setInfo(
            info: AvalancheCChainApi.Info(
                gasPrice: 470.gwei,
                chainId: 43111,
                bId: "2fFZQibQXcd6LTE4rpBPBAkLVXFE91Kit8pgxaBG1mRnh5xqbb",
                alias: "C"
            ),
            for: AvalancheCChainApi.self
        )
        netApis.setInfo(
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
        return AvalancheDefaultNetworkInfo(hrp: "custom", apiInfo: netApis)
    }
    
    // AvalancheNetwork.main || AvalancheNetwork.avalanche
    private static func avalancheNetInfo() -> AvalancheDefaultNetworkInfo {
        let netApis = AvalancheDefaultApiInfoProvider()
        addNonVmApis(to: netApis)
        netApis.setInfo(
            info: AvalancheXChainApi.Info(
                txFee: .milliAVAX,
                creationTxFee: .centiAVAX,
                bId: "2oYMBNV4eNHyqk2fjjV5nVQLDbtmNJzq5s3qs3Lo6ftnC6FByM",
                alias: "X"
            ),
            for: AvalancheXChainApi.self
        )
        netApis.setInfo(
            info: AvalancheCChainApi.Info(
                gasPrice: 470.gwei,
                chainId: 43114,
                bId: "2q9e4r6Mu3U68nU1fYjgbR6JvwrRx36CohpAX5UQxse55x1Q5",
                alias: "C"
            ),
            for: AvalancheCChainApi.self
        )
        netApis.setInfo(
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
        return AvalancheDefaultNetworkInfo(hrp: "avax", apiInfo: netApis)
    }
    
    // AvalancheNetwork.test || AvalancheNetwork.fuji
    private static func fujiNetInfo() -> AvalancheDefaultNetworkInfo {
        let netApis = AvalancheDefaultApiInfoProvider()
        addNonVmApis(to: netApis)
        netApis.setInfo(
            info: AvalancheXChainApi.Info(
                txFee: .milliAVAX,
                creationTxFee: .centiAVAX,
                bId: "2JVSBoinj9C2J33VntvzYtVJNZdN2NKiwwKjcumHUWEb5DbBrm",
                alias: "X"
            ),
            for: AvalancheXChainApi.self
        )
        netApis.setInfo(
            info: AvalancheCChainApi.Info(
                gasPrice: 470.gwei,
                chainId: 43113,
                bId: "yH8D7ThNJkxmtkuv2jgBa4P1Rn3Qpr4pPr7QYNfcdoS6k6HWp",
                alias: "C"
            ),
            for: AvalancheCChainApi.self
        )
        netApis.setInfo(
            info: AvalanchePChainApi.Info(
                minConsumption: 0.1,
                maxConsumption: 0.12,
                maxStakingDuration: 31536000,
                maxSupply: 720000000.AVAX,
                minStake: 1.AVAX,
                minStakeDuration: 24 * 60 * 60, //one day
                maxStakeDuration: 365 * 24 * 60 * 60, // one year
                minDelegationStake: 1.AVAX,
                minDelegationFee: 2.AVAX,
                txFee: .milliAVAX,
                creationTxFee: .centiAVAX,
                bId: "11111111111111111111111111111111LpoYY",
                alias: "P"
            ),
            for: AvalanchePChainApi.self
        )
        return AvalancheDefaultNetworkInfo(hrp: "fuji", apiInfo: netApis)
    }
}
