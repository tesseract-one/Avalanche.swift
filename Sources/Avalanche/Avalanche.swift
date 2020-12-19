//
//  Avalanche.swift
//
//
//  Created by Yehor Popovych on 9/5/20.
//

import Foundation
//import RPC

public class Avalanche: AvalancheCore {
    private var apis: [String: Any]
    private let lock: NSRecursiveLock
    
    private let _url: URL
    public let settings: AvalancheSettings
    
    public var keychains: AvalancheKeychainFactory {
        willSet { lock.lock() }
        didSet { lock.unlock(); clearApis() }
    }
    
    public var networkInfo: AvalancheNetworkInfoProvider {
        willSet { lock.lock() }
        didSet { lock.unlock(); clearApis() }
    }
    
    public var network: AvalancheNetwork {
        willSet { lock.lock() }
        didSet { lock.unlock(); clearApis() }
    }
    
    public required init(url: URL, keychains: AvalancheKeychainFactory, networkInfo: AvalancheNetworkInfoProvider, settings: AvalancheSettings) {
        self._url = url
        self.apis = [:]
        self.network = .main
        self.keychains = keychains
        self.networkInfo = networkInfo
        self.settings = settings
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
    
    public func url(path: String) -> URL {
        URL(string: path, relativeTo: _url)!
    }
    
    private func clearApis() {
        lock.lock()
        defer { lock.unlock() }
        apis = [:]
    }
}
