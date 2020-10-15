//
//  Avalanche.swift
//
//
//  Created by Yehor Popovych on 9/5/20.
//

import Foundation

public class Avalanche: AvalancheCore {    
    private var apis: [String: Any]
    private let lock: NSRecursiveLock
    
    public var connections: AvalancheConnectionFactory  {
        didSet { clearApis() }
    }
    
    public var keychains: AvalancheKeychainFactory {
        didSet { clearApis() }
    }
    
    public var networkInfo: AvalancheNetworkInfoProvider {
        didSet { clearApis() }
    }
    
    public var network: AvalancheNetwork {
        didSet { clearApis() }
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
        self.lock = NSRecursiveLock()
    }
    
    public func getAPI<API: AvalancheApi>() throws -> API {
        lock.lock()
        defer { lock.unlock() }
        
        if let api = self.apis[API.id] as? API {
            return api
        }
        guard let netInfo = self.networkInfo.info(for: network) else {
            throw AvalancheApiSearchError.networkInfoNotFound(net: network)
        }
        guard let info = netInfo.apiInfo.info(for: API.self) else {
            throw AvalancheApiSearchError.apiInfoNotFound(net: network, apiId: API.id)
        }
        let api: API = self.createAPI(network: network, hrp: netInfo.hrp, info: info)
        self.apis[API.id] = api
        return api
    }
    
    public func createAPI<API: AvalancheApi>(network: AvalancheNetwork, hrp: String, info: API.Info) -> API {
        lock.lock()
        defer { lock.unlock() }
        return API(avalanche: self, network: network, hrp: hrp, info: info)
    }
    
    private func clearApis() {
        lock.lock()
        defer { lock.unlock() }
        apis = [:]
    }
}
