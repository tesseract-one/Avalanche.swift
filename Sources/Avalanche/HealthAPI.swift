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
    
    private let network: AvalancheRpcConnection
    
    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: AvalancheHealthApiInfo) {
        self.network = avalanche.connections.httpRpcConnection(for: info.apiPath);
    }
    
    public func getLiveness(cb: @escaping AvalancheRpcConnectionCallback<VoidCallParams, AvalancheLivenessResponse, SerializableValue>) {
        network.call(
            method: "health.getLiveness",
            params: [], // empty array
            AvalancheLivenessResponse.self,
            response: cb
        )
    }
}

extension AvalancheCore {
    public var Health: AvalancheHealthApi {
        return try! self.getAPI()
    }
}
