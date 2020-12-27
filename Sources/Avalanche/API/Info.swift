//
//  Info.swift
//  
//
//  Created by Daniel Leping on 23/12/2020.
//

import Foundation
import Serializable
#if !COCOAPODS
import RPC
#endif

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
    
    public struct GetBlockchainIDParams: Encodable {
        let alias: String
    }
    
    public func getBlockchainID(alias: String, cb: @escaping RequestCallback<GetBlockchainIDParams, String, SerializableValue>) {
        struct GetBlockchainIDResponse: Decodable {
            let blockchainID: String
        }
        
        service.call(
            method: "info.getBlockchainID",
            params: GetBlockchainIDParams(alias: alias),
            GetBlockchainIDResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.map {$0.blockchainID})
        }
    }

    
    
    public func getNetworkID(cb: @escaping RequestCallback<Nil, UInt, SerializableValue>) {
        struct GetNetworkIDResponse: Decodable {
            let networkID: String
        }
        
        service.call(
            method: "info.getNetworkID",
            params: Nil.nil,
            GetNetworkIDResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { response in
                UInt(response.networkID).map {.success($0)}
                    ??
                    .failure(.custom(description: "server returned '" + response.networkID + "' ID which is not UInt", cause: nil))
            })
        }
    }
    
    public func getNetworkName(cb: @escaping RequestCallback<Nil, String, SerializableValue>) {
        struct GetNetworkNameResponse: Decodable {
            let networkName: String
        }
        
        service.call(
            method: "info.getNetworkName",
            params: Nil.nil,
            GetNetworkNameResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.map {$0.networkName})
        }
    }
    
    public func getNodeID(cb: @escaping RequestCallback<Nil, String, SerializableValue>) {
        struct GetNodeIDResponse: Decodable {
            let nodeID: String
        }
        
        service.call(
            method: "info.getNodeID",
            params: Nil.nil,
            GetNodeIDResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.map {$0.nodeID})
        }
    }
    
    public func getNodeIP(cb: @escaping RequestCallback<Nil, String, SerializableValue>) {
        struct GetNodeIPResponse: Decodable {
            let ip: String
        }
        
        service.call(
            method: "info.getNodeIP",
            params: Nil.nil,
            GetNodeIPResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.map {$0.ip})
        }
    }
    
    public func getNodeVersion(cb: @escaping RequestCallback<Nil, String, SerializableValue>) {
        struct GetNodeVersionResponse: Decodable {
            let version: String
        }
        
        service.call(
            method: "info.getNodeVersion",
            params: Nil.nil,
            GetNodeVersionResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.map {$0.version})
        }
    }
    
    
    public struct IsBootstrappedParams: Encodable {
        let chain: String
    }
    
    public func isBootstrapped(chain: String, cb: @escaping RequestCallback<IsBootstrappedParams, Bool, SerializableValue>) {
        struct IsBootstrappedResponse: Decodable {
            let isBootstrapped: Bool
        }
        
        service.call(
            method: "info.isBootstrapped",
            params: IsBootstrappedParams(chain: chain),
            IsBootstrappedResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.map {$0.isBootstrapped})
        }
    }
    
    public struct Peer: Decodable {
        let ip: String
        let publicIP: String
        let nodeID: String
        let version: String
        let lastSent: String
        let lastReceived: String
    }
    
    public func peers(cb: @escaping RequestCallback<Nil, [Peer], SerializableValue>) {
        struct PeersResponse: Decodable {
            //seriously???
            let numPeers: String
            let peers: [Peer]
        }
        
        service.call(
            method: "info.peers",
            params: Nil.nil,
            PeersResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.map {$0.peers})
        }
    }
    
    public struct TxFee: Decodable {
        let creationTxFee: UInt64
        let txFee: UInt64
    }
    
    public func getTxFee(cb: @escaping RequestCallback<Nil, TxFee, SerializableValue>) {
        struct GetTxFeeResponse: Decodable {
            let creationTxFee: String
            let txFee: String
        }
        
        service.call(
            method: "info.getTxFee",
            params: Nil.nil,
            GetTxFeeResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { response in
                guard let ctf = UInt64(response.creationTxFee) else {
                    return .failure(.custom(description: "server returned '" + response.creationTxFee + "' creationTxFee which is not UInt64", cause: nil))
                }
                
                guard let tf = UInt64(response.txFee) else {
                    return .failure(.custom(description: "server returned '" + response.txFee + "' txFee which is not UInt64", cause: nil))
                }
                
                return .success(TxFee(creationTxFee: ctf, txFee: tf))
            })
        }
    }
}

extension AvalancheCore {
    public var info: AvalancheInfoApi {
        try! self.getAPI()
    }
}
