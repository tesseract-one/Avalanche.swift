//
//  File.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import Foundation

import RPC
import Serializable

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
    
    struct AdminResponse: Decodable {
        let success: Bool
        
        func toResult<P: Encodable, E: Decodable>() -> Result<Nil, RequestError<P, E>> {
            success ? .success(.nil) : .failure(.custom(description: "Service returned success = false", cause: nil))
        }
    }
    
    public struct AliasParams: Encodable {
        let alias: String
        let endpoint: String
    }
    
    public func alias(alias: String, endpoint: String, cb: @escaping RequestCallback<AliasParams, Nil, SerializableValue>) {
        service.call(
            method: "admin.alias",
            params: AliasParams(alias: alias, endpoint: endpoint),
            AdminResponse.self,
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
            AdminResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public func lockProfile(cb: @escaping RequestCallback<Nil, Nil, SerializableValue>) {
        service.call(
            method: "admin.lockProfile",
            params: .nil,
            AdminResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public func memoryProfile(cb: @escaping RequestCallback<Nil, Nil, SerializableValue>) {
        service.call(
            method: "admin.memoryProfile",
            params: .nil,
            AdminResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public func startCPUProfiler(cb: @escaping RequestCallback<Nil, Nil, SerializableValue>) {
        service.call(
            method: "admin.startCPUProfiler",
            params: .nil,
            AdminResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    public func stopCPUProfiler(cb: @escaping RequestCallback<Nil, Nil, SerializableValue>) {
        service.call(
            method: "admin.stopCPUProfiler",
            params: .nil,
            AdminResponse.self,
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
