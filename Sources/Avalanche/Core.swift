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
}
