//
//  Core.swift
//  
//
//  Created by Yehor Popovych on 9/5/20.
//

import Foundation

public typealias AvalancheResponseCallback<R, E: Error> = (Result<R, E>) -> ()

public enum AvalancheApiSearchError: Error {
    case networkInfoNotFound(net: AvalancheNetwork)
    case apiInfoNotFound(net: AvalancheNetwork, apiId: String)
}

public protocol AvalancheCore: class {
    var connections: AvalancheConnectionFactory { get }
    var keychains: AvalancheKeychainFactory { get }
    var networkInfo: AvalancheNetworkInfoProvider { get }
    
    var network: AvalancheNetwork { get set }
    
    init(
        connections: AvalancheConnectionFactory,
        keychains: AvalancheKeychainFactory,
        networkInfo: AvalancheNetworkInfoProvider
    )
    
    func getAPI<A: AvalancheApi>() throws -> A
    func createAPI<A: AvalancheApi>(network: AvalancheNetwork, hrp: String, info: A.Info) -> A
}


extension AvalancheCore {
    public init(
        connections: AvalancheConnectionFactory,
        keychains: AvalancheKeychainFactory,
        network: AvalancheNetwork,
        hrp: String,
        apiInfo: AvalancheApiInfoProvider
    ) {
        let provider = AvalancheDefaultNetworkInfoProvider()
        let netInfo = AvalancheDefaultNetworkInfo(hrp: hrp, apiInfo: apiInfo)
        provider.setInfo(info: netInfo, for: network)
        self.init(connections: connections, keychains: keychains, networkInfo: provider)
        self.network = network
    }
    
    public init(
        url: URL,
        keychains: AvalancheKeychainFactory,
        network: AvalancheNetwork = .main,
        networkInfo: AvalancheNetworkInfoProvider = AvalancheDefaultNetworkInfoProvider.default
    ) {
        let connections = AvalancheDefaultConnectionFactory(url: url)
        self.init(connections: connections, keychains: keychains, networkInfo: networkInfo)
    }
    
    public init(
        url: URL, keychains: AvalancheKeychainFactory,
        network: AvalancheNetwork, hrp: String,
        apiInfo: AvalancheApiInfoProvider
    ) {
        let connections = AvalancheDefaultConnectionFactory(url: url)
        self.init(connections: connections, keychains: keychains, network: network, hrp: hrp, apiInfo: apiInfo)
    }
}
