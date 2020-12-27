//
//  HealthAPI.swift
//  
//
//  Created by Yehor Popovych on 10/26/20.
//

import Foundation
import Serializable
import RPC

public struct AvalancheHealthApiInfo: AvalancheApiInfo {
    public let apiPath: String = "/ext/health"
}

public struct AvalancheLivenessResponse: Decodable {
    public struct Check: Decodable {
        public let message: Dictionary<String, SerializableValue>?
        public let error: Dictionary<String, SerializableValue>?
        public let timestamp: Date
        public let duration: UInt64
        public let contiguousFailures: UInt32
        public let timeOfFirstFailure: Date?
    }
    
    public let healthy: Bool
    public let checks: Dictionary<String, Check>
}

public class AvalancheHealthApi: AvalancheApi {
    public typealias Info = AvalancheHealthApiInfo
    
    private let service: Client
    
    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: AvalancheHealthApiInfo) {
        let settings = avalanche.settings
        let url = avalanche.url(path: info.apiPath)
        
        self.service = JsonRpc(.http(url: url, session: settings.session, headers: settings.headers), queue: settings.queue, encoder: settings.encoder, decoder: settings.decoder)
    }
    
    public func getLiveness(cb: @escaping RequestCallback<Nil, AvalancheLivenessResponse, SerializableValue>) {
        service.call(
            method: "health.getLiveness",
            params: nil,
            AvalancheLivenessResponse.self,
            SerializableValue.self,
            response: cb
        )
    }
}

extension AvalancheCore {
    public var health: AvalancheHealthApi {
        try! self.getAPI()
    }
}

//let Service: protocol<ClientService, ServerService> = Service(
