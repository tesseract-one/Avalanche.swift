//
//  Avalanche.swift
//
//
//  Created by Yehor Popovych on 9/5/20.
//

import Foundation

public class Avalanche: AvalancheCore {    
    private var apis: [String: Any]
    
    public var connections: AvalancheConnectionFactory  {
        didSet { apis = [:] }
    }
    
    public var keychains: AvalancheKeychainFactory {
        didSet { apis = [:] }
    }
    
    public var networkInfo: AvalancheNetworkInfoProvider {
        didSet { apis = [:] }
    }
    
    public var network: AvalancheNetwork {
        didSet { apis = [:] }
    }
    
    required public init(
        connections: AvalancheConnectionFactory,
        keychains: AvalancheKeychainFactory,
        networkInfo: AvalancheNetworkInfoProvider = AvalancheDefaultNetworkInfoProvider.default
    ) {
        self.apis = [:]
        self.network = .main
        self.connections = connections
        self.keychains = keychains
        self.networkInfo = networkInfo
    }
    
    public func getAPI<API: AvalancheApi>() throws -> API {
        if let api = self.apis[API.id] as? API {
            return api
        }
        guard let netInfo = self.networkInfo.info(for: network) else {
            throw AvalancheApiSearchError.networkInfoNotFound(net: network)
        }
        guard let info = netInfo.apiInfo.info(for: API.self) else {
            throw AvalancheApiSearchError.apiInfoNotFound(net: network, apiId: API.id)
        }
        let api = API(avalanche: self, info: info)
        self.apis[API.id] = api
        return api
    }
}

