//
//  Admin.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import Foundation
import Serializable
#if !COCOAPODS
import RPC
#endif

public struct AvalancheAdminApiInfo: AvalancheApiInfo {
    public let apiPath: String = "/ext/admin"
}

public class AvalancheAdminApi: AvalancheApi {
    public typealias Info = AvalancheAdminApiInfo

    private let service: Client

    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: AvalancheAdminApiInfo) {
        let settings = avalanche.settings
        let url = avalanche.url(path: info.apiPath)
        
        self.service = JsonRpc(.http(url: url, session: settings.session, headers: settings.headers), queue: settings.queue, encoder: settings.encoder, decoder: settings.decoder)
    }
    
    public struct AliasParams: Encodable {
        let alias: String
        let endpoint: String
    }
    
    public func alias(alias: String, endpoint: String, cb: @escaping RequestCallback<AliasParams, Nil, SerializableValue>) {
        service.call(
            method: "admin.alias",
            params: AliasParams(alias: alias, endpoint: endpoint),
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public struct AliasChainParams: Encodable {
        let chain: String
        let alias: String
    }
    
    public func aliasChain(chain: String, alias: String, cb: @escaping RequestCallback<AliasChainParams, Nil, SerializableValue>) {
        service.call(
            method: "admin.aliasChain",
            params: AliasChainParams(chain: chain, alias: alias),
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public func lockProfile(cb: @escaping RequestCallback<Nil, Nil, SerializableValue>) {
        service.call(
            method: "admin.lockProfile",
            params: .nil,
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public func memoryProfile(cb: @escaping RequestCallback<Nil, Nil, SerializableValue>) {
        service.call(
            method: "admin.memoryProfile",
            params: .nil,
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public func startCPUProfiler(cb: @escaping RequestCallback<Nil, Nil, SerializableValue>) {
        service.call(
            method: "admin.startCPUProfiler",
            params: .nil,
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    public func stopCPUProfiler(cb: @escaping RequestCallback<Nil, Nil, SerializableValue>) {
        service.call(
            method: "admin.stopCPUProfiler",
            params: .nil,
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
}

extension AvalancheCore {
    public var admin: AvalancheAdminApi {
        try! self.getAPI()
    }
}
