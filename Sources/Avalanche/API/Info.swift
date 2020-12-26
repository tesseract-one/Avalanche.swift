//
//  File.swift
//  
//
//  Created by Daniel Leping on 23/12/2020.
//

import Foundation

import RPC
import Serializable

public struct AvalancheInfoApiInfo: AvalancheApiInfo {
    public let apiPath: String = "/ext/info"
}

public class AvalancheInfoApi: AvalancheApi {
    public typealias Info = AvalancheInfoApiInfo
    
    private let service: Client
    
    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: AvalancheInfoApiInfo) {
        let settings = avalanche.settings
        let url = avalanche.url(path: info.apiPath)
        
        self.service = JsonRpc(.http(url: url, session: settings.session, headers: settings.headers), queue: settings.queue, encoder: settings.encoder, decoder: settings.decoder)
    }
    
    /// methods
    
    public struct GetBlockchainIDResponse: Decodable {
        let blockchainID: String
    }
    
    public struct GetBlockchainIDParams: Encodable {
        let alias: String
    }
    
    //TODO: create alias enum
    public func getBlockchainID(alias: String, cb: @escaping RequestCallback<GetBlockchainIDParams, GetBlockchainIDResponse, SerializableValue>) {
        service.call(
            method: "info.getBlockchainID",
            params: GetBlockchainIDParams(alias: alias),
            GetBlockchainIDResponse.self,
            SerializableValue.self,
            response: cb
        )
    }
    
    
    
    public struct GetNetworkIDResponse: Decodable {
        let networkID: String
    }
    
    public func getNetworkID(cb: @escaping RequestCallback<Nil, GetNetworkIDResponse, SerializableValue>) {
        service.call(
            method: "info.getNetworkID",
            params: .nil,
            GetNetworkIDResponse.self,
            SerializableValue.self,
            response: cb
        )
    }
}

extension AvalancheCore {
    public var info: AvalancheInfoApi {
        try! self.getAPI()
    }
}
